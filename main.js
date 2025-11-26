const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const Store = require('electron-store');
const fetch = require('node-fetch');
const WebSocket = require('ws');

const store = new Store();

let mainWindow;

function createWindow () {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js')
    }
  });

  mainWindow.loadFile('index.html');
}

app.whenReady().then(() => {
  createWindow();

  app.on('activate', function () {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });

  checkLiveStatus();
  setInterval(checkLiveStatus, 15 * 1000); // Check every 15 seconds
});

app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit();
});

ipcMain.handle('get-settings', () => {
  return {
    channels: store.get('channels') || [],
    obsSettings: store.get('obsSettings') || { host: 'localhost', port: '4455', password: '' },
    verboseLogging: store.get('verboseLogging') || false,
    priorityChannel: store.get('priorityChannel') || null,
    cookies: store.get('cookies') || ''
  };
});

ipcMain.on('save-settings', (_event, settings) => {
  store.set('channels', settings.channels);
  store.set('obsSettings', settings.obsSettings);
  store.set('verboseLogging', settings.verboseLogging);
  store.set('priorityChannel', settings.priorityChannel);
  store.set('cookies', settings.cookies);
});

let liveChannels = [];
let currentStream = null;
let ws = null;
let isStopping = false;
let isTabActive = false;
let lastTabAction = 0;
let lastLiveStatus = {};
let pingInterval = null;
let isIdentified = false;

async function computeSha256(str) {
  const buffer = new TextEncoder().encode(str);
  const crypto = require('crypto');
  return crypto.createHash('sha256').update(buffer).digest();
}

function arrayBufferToBase64(buffer) {
  return buffer.toString('base64');
}

async function isChannelLive(channelId, verboseLogging) {
  const liveUrl = `https://www.youtube.com/channel/${channelId}/live`;
  log(verboseLogging, `Fetching live status for channel ${channelId}: ${liveUrl}`);
  const cookies = store.get('cookies') || '';

  try {
    const response = await fetch(liveUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Cookie': cookies
      }
    });
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }
    const html = await response.text();
    log(verboseLogging, `Successfully fetched /live page for channel ${channelId}`);

    if (html.includes('"isLive":true')) {
      const canonicalMatch = html.match(/<link rel="canonical" href="https:\/\/www\.youtube\.com\/watch\?v=([^"]+)">/);
      if (canonicalMatch) {
        const videoId = canonicalMatch[1];
        log(verboseLogging, `Found video ID: ${videoId} for channel ${channelId}`);
        return { isLive: true, videoId };
      } else {
        log(verboseLogging, `Live stream detected but no video ID found for channel ${channelId}`);
        return { isLive: false };
      }
    }
    log(verboseLogging, `No live stream detected for channel ${channelId}`);
    return { isLive: false };
  } catch (error) {
    log(verboseLogging, `Error checking live status for ${channelId}: ${error.message}`);
    return { isLive: false };
  }
}

async function checkLiveStatus() {
  const { verboseLogging = false } = { verboseLogging: store.get('verboseLogging') };
  log(verboseLogging, 'Starting live status check');
  log(verboseLogging, `Verbose logging enabled: ${verboseLogging}`);

  const channels = store.get('channels') || [];
  const priorityChannel = store.get('priorityChannel') || null;
  log(verboseLogging, `Retrieved ${channels.length} channels from storage: ${JSON.stringify(channels)}`);
  log(verboseLogging, `Priority channel: ${priorityChannel}`);

  const liveChannels = [];
  for (const channel of channels) {
    const isLive = await isChannelLive(channel.id, verboseLogging);
    if (isLive.isLive && isLive.videoId) {
      liveChannels.push({ ...channel, videoId: isLive.videoId });
      lastLiveStatus[channel.id] = { isLive: true, videoId: isLive.videoId };
      log(verboseLogging, `Channel ${channel.displayName} (${channel.id}) is live with video ID ${isLive.videoId}`);
    } else if (lastLiveStatus[channel.id]?.isLive && !isLive.isLive) {
      log(verboseLogging, `Channel ${channel.displayName} (${channel.id}) may have ended, fetch failed`);
    } else {
      log(verboseLogging, `Channel ${channel.displayName} (${channel.id}) is not live`);
      delete lastLiveStatus[channel.id];
    }
  }

  log(verboseLogging, `Found ${liveChannels.length} live channels`);
  mainWindow.webContents.send('update-live-channels', liveChannels);


  let selectedChannel = null;
  const currentLiveChannelId = store.get('currentLiveChannelId');
  log(verboseLogging, `Current live channel ID from storage: ${currentLiveChannelId}`);

  for (const channel of channels) {
    const liveChannel = liveChannels.find(ch => ch.id === channel.id);
    if (liveChannel) {
      selectedChannel = liveChannel;
      break;
    }
  }

  if (!selectedChannel && liveChannels.length > 0) {
    selectedChannel = liveChannels[0];
  }

  if (!selectedChannel) {
    log(verboseLogging, `No live channels, stopping streaming`);
    await stopObsStreaming(verboseLogging);
    store.set('currentLiveChannelId', null);
    currentStream = null;
    return;
  }

  const now = Date.now();
  if (now - lastTabAction < 30000 && currentLiveChannelId === selectedChannel.id) {
    log(verboseLogging, 'Tab action debounced, skipping');
    return;
  }

  if (currentStream && currentStream.channelId === selectedChannel.id) {
    log(verboseLogging, `Already handling stream for ${selectedChannel.displayName}`);
    return;
  }

  currentStream = { channelId: selectedChannel.id, videoId: selectedChannel.videoId, obsAction: selectedChannel.obsAction };
  store.set('currentLiveChannelId', selectedChannel.id);
  
  // Trigger keyword analysis for the new stream
  triggerKeywordAnalysis(selectedChannel, verboseLogging);

  if (selectedChannel.obsAction !== 'no-obs') {
    await startObsStreaming(selectedChannel.obsAction, verboseLogging);
  }
  lastTabAction = now;
}

async function triggerKeywordAnalysis(channel, verboseLogging) {
  if (!channel.keywords || channel.keywords.trim() === '') {
    log(verboseLogging, `No keywords set for ${channel.displayName}, skipping analysis.`);
    return;
  }

  const videoUrl = `https://www.youtube.com/watch?v=${channel.videoId}`;
  const keywords = channel.keywords.split(',').map(k => k.trim()).filter(k => k);

  if (keywords.length === 0) {
    log(verboseLogging, `Keyword field for ${channel.displayName} is present but contains no actual keywords, skipping analysis.`);
    return;
  }
  
  log(verboseLogging, `Triggering keyword analysis for ${channel.displayName} on video ${videoUrl} with keywords: [${keywords.join(', ')}]`);
  
  // Update UI with analysis status
  mainWindow.webContents.send('update-analysis-status', `Analyzing ${channel.displayName}...`);

  try {
    const response = await fetch('http://localhost:5001/analyze', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        video_url: videoUrl,
        keywords: keywords,
      }),
    });

    if (response.ok) {
      const result = await response.json();
      log(verboseLogging, `Successfully sent analysis request to backend: ${result.message}`);
      mainWindow.webContents.send('update-analysis-status', 
        `Found ${result.matches.length} matches for ${channel.displayName}`);
    } else {
      log(verboseLogging, `Failed to send analysis request to backend. Status: ${response.status}`);
      mainWindow.webContents.send('update-analysis-status', 'Analysis failed - check backend');
    }
  } catch (error) {
    log(verboseLogging, `Error calling analysis backend: ${error.message}`);
    mainWindow.webContents.send('update-analysis-status', 'Backend offline');
  }
}


async function ensureObsConnected(verboseLogging) {
  return new Promise((resolve, reject) => {
    const obsSettings = store.get('obsSettings');
    if (!obsSettings || !obsSettings.host || !obsSettings.port) {
      log(verboseLogging, 'OBS settings not configured. Please set host and port in options.');
      reject(new Error('OBS settings not configured'));
      return;
    }
    log(verboseLogging, `Attempting connection to OBS at ${obsSettings.host}:${obsSettings.port}, password: ${obsSettings.password ? 'set' : 'not set'}`);
    const { host, port, password } = obsSettings;
    const wsUrl = `ws://${host}:${port}`;

    if (ws && ws.readyState === WebSocket.OPEN && isIdentified) {
      log(verboseLogging, 'WebSocket already open and identified');
      resolve();
      return;
    }

    if (ws && (ws.readyState === WebSocket.CLOSING || ws.readyState === WebSocket.CLOSED)) {
      log(verboseLogging, 'Previous WebSocket connection closed, resetting');
      ws = null;
    }

    if (!ws) {
      log(verboseLogging, `Creating new WebSocket connection to ${wsUrl}`);
      ws = new WebSocket(wsUrl);
    }

    ws.on('open', () => {
      log(verboseLogging, 'WebSocket connection opened');
    });

    ws.on('message', async (data) => {
      const message = JSON.parse(data);
      log(verboseLogging, `Received message: ${JSON.stringify(message)}`);
      if (message.op === 0) { // Hello
        if (message.d.authentication) {
          const { salt, challenge } = message.d.authentication;
          log(verboseLogging, `Authentication required. Salt: ${salt}, Challenge: ${challenge}`);
          try {
            const secretHash = await computeSha256(password + salt);
            const secret = arrayBufferToBase64(secretHash);
            log(verboseLogging, `Computed secret: ${secret}`);
            const authHash = await computeSha256(secret + challenge);
            const auth = arrayBufferToBase64(authHash);
            log(verboseLogging, `Computed auth: ${auth}`);
            if (ws && ws.readyState === WebSocket.OPEN) {
              ws.send(JSON.stringify({
                op: 1,
                d: {
                  rpcVersion: 1,
                  authentication: auth,
                  eventSubscriptions: 0
                }
              }));
              log(verboseLogging, 'Sent Identify message');
            } else {
              log(verboseLogging, 'WebSocket not open, cannot send Identify message');
              reject(new Error('WebSocket not open'));
            }
          } catch (error) {
            log(verboseLogging, `Error computing authentication: ${error.message}`);
            reject(error);
          }
        } else {
          log(verboseLogging, 'No authentication required');
          if (ws && ws.readyState === WebSocket.OPEN) {
            ws.send(JSON.stringify({
              op: 1,
              d: {
                rpcVersion: 1,
                eventSubscriptions: 0
              }
            }));
            log(verboseLogging, 'Sent Identify message');
          } else {
            log(verboseLogging, 'WebSocket not open, cannot send Identify message');
            reject(new Error('WebSocket not open'));
          }
        }
      } else if (message.op === 2) { // Identified
        log(verboseLogging, 'Identified successfully');
        isIdentified = true;
        if (!pingInterval) {
          pingInterval = setInterval(() => {
            if (ws && ws.readyState === WebSocket.OPEN) {
              ws.send(JSON.stringify({ op: 9, d: { eventType: "Ping" } }));
              log(verboseLogging, 'Sent WebSocket ping to keep connection alive');
            }
          }, 10000); // Ping every 10 seconds
        }
        resolve();
      } else if (message.op === 7) { // RequestResponse
        if (message.d.requestType === "StartStream" || message.d.requestType === "StartRecord") {
          if (message.d.requestStatus.result) {
            log(verboseLogging, `OBS ${message.d.requestType === "StartStream" ? "streaming" : "recording"} started successfully`);
          } else {
            log(verboseLogging, `Failed to ${message.d.requestType === "StartStream" ? "start streaming" : "start recording"}: ${JSON.stringify(message.d.requestStatus)}`);
          }
        } else if (message.d.requestType === "StopStream" || message.d.requestType === "StopRecord") {
          if (message.d.requestStatus.result) {
            log(verboseLogging, `OBS ${message.d.requestType === "StopStream" ? "streaming" : "recording"} stopped successfully`);
          } else {
            log(verboseLogging, `Failed to ${message.d.requestType === "StopStream" ? "stop streaming" : "stop recording"}: ${JSON.stringify(message.d.requestStatus)}`);
          }
        }
      }
    });

    ws.on('error', (error) => {
      const errorMsg = error.message || error;
      log(verboseLogging, `WebSocket error: ${errorMsg}`);
      reject(error);
    });

    ws.on('close', (code, reason) => {
      log(verboseLogging, `WebSocket connection closed: code ${code}, reason ${reason}`);
      if (pingInterval) {
        clearInterval(pingInterval);
        pingInterval = null;
      }
      isIdentified = false;
      ws = null;
      resolve();
    });
  });
}

async function startObsStreaming(action, verboseLogging) {
  try {
    log(verboseLogging, `Attempting to start OBS ${action}`);
    await ensureObsConnected(verboseLogging);
    if (ws && ws.readyState === WebSocket.OPEN) {
      const requestType = action === 'stream' ? 'StartStream' : 'StartRecord';
      ws.send(JSON.stringify({
        op: 6,
        d: {
          requestType: requestType,
          requestId: `${requestType.toLowerCase()}_request`
        }
      }));
      log(verboseLogging, `Sent ${requestType} request`);
    } else {
      log(verboseLogging, `WebSocket not open (state: ${ws ? ws.readyState : 'null'}), cannot send ${action} request`);
    }
  } catch (error) {
    log(verboseLogging, `Error starting OBS ${action}: ${error.message}`);
  }
}

async function stopObsStreaming(verboseLogging) {
  if (isStopping) {
    log(verboseLogging, 'Stop streaming/recording already in progress, skipping');
    return;
  }
  isStopping = true;

  try {
    log(verboseLogging, 'Attempting to stop OBS streaming and recording');
    await ensureObsConnected(verboseLogging);
    if (ws && ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify({
        op: 6,
        d: {
          requestType: "StopStream",
          requestId: "stop_stream"
        }
      }));
      ws.send(JSON.stringify({
        op: 6,
        d: {
          requestType: "StopRecord",
          requestId: "stop_record"
        }
      }));
      log(verboseLogging, 'Sending StopStream and StopRecord requests to OBS');
    } else {
      log(verboseLogging, 'WebSocket not open after reconnect attempt, cannot stop streaming/recording');
    }
  } catch (error) {
    log(verboseLogging, `Error stopping OBS: ${error.message}`);
  } finally {
    isStopping = false;
  }
}

function log(verbose, message) {
  if (verbose) {
    console.log(`[YouTube Live Monitor] ${message}`);
  }
}
