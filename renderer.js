document.getElementById('add-channel').addEventListener('click', () => {
  const div = document.createElement('div');
  div.className = 'channel-input';
  div.draggable = true;
  div.innerHTML = `
    <span class="drag-handle">☰</span>
    <input type="text" class="display-name" placeholder="Display name">
    <input type="text" class="keywords" placeholder="Keywords (comma-separated)">
    <input type="hidden" class="channel-id" value="">
    <select class="obs-action">
      <option value="no-obs" selected>No OBS</option>
      <option value="stream">Stream</option>
      <option value="record">Record</option>
    </select>
    <button class="remove">Remove</button>
  `;
  document.getElementById('channels').appendChild(div);
});

document.getElementById('channels').addEventListener('click', (e) => {
  if (e.target.className === 'remove') {
    e.target.parentElement.remove();
  }
});

document.getElementById('channels').addEventListener('dragstart', (e) => {
  if (e.target.className.includes('channel-input')) {
    e.target.classList.add('dragging');
    e.dataTransfer.setData('text/plain', e.target.innerHTML);
  }
});

document.getElementById('channels').addEventListener('dragover', (e) => {
  e.preventDefault();
});

document.getElementById('channels').addEventListener('drop', (e) => {
  e.preventDefault();
  const dragging = document.querySelector('.dragging');
  if (dragging) {
    const target = e.target.closest('.channel-input');
    if (target && target !== dragging) {
      const containers = Array.from(document.querySelectorAll('.channel-input'));
      const draggingIndex = containers.indexOf(dragging);
      const targetIndex = containers.indexOf(target);
      if (draggingIndex > -1 && targetIndex > -1) {
        if (draggingIndex < targetIndex) {
          target.parentNode.insertBefore(dragging, target.nextSibling);
        } else {
          target.parentNode.insertBefore(dragging, target);
        }
      }
    }
    dragging.classList.remove('dragging');
  }
});

document.getElementById('save').addEventListener('click', async () => {
  const saveBtn = document.getElementById('save');
  saveBtn.disabled = true;
  saveBtn.textContent = 'Saving...';
  
  try {
    const inputs = document.querySelectorAll('.channel-input');
    const channels = [];
    let priorityChannel = null;
    const obsSettings = {
      host: document.getElementById('obs-host').value.trim() || 'localhost',
      port: document.getElementById('obs-port').value.trim() || '4455',
      password: document.getElementById('obs-password').value.trim()
    };
    const verboseLogging = document.getElementById('verbose-logging').checked;
    const cookies = document.getElementById('cookies').value.trim();

    let hasError = false;
    for (const inputDiv of inputs) {
      const displayNameInput = inputDiv.querySelector('.display-name').value.trim();
      const channelIdInput = inputDiv.querySelector('.channel-id');
      const obsAction = inputDiv.querySelector('.obs-action').value;
      const keywords = inputDiv.querySelector('.keywords').value.trim();

      if (displayNameInput) {
        try {
          let channelId = channelIdInput.value || await getChannelIdFromDisplayName(displayNameInput);
          if (channelId) {
            channels.push({ id: channelId, displayName: displayNameInput, obsAction, keywords });
            channelIdInput.value = channelId; // Store the resolved ID
          } else {
            alert(`Could not find channel ID for ${displayNameInput}. Please check the channel name.`);
            hasError = true;
            break;
          }
        } catch (error) {
          console.error('Error resolving channel:', error);
          alert(`Error resolving channel ${displayNameInput}: ${error.message}`);
          hasError = true;
          break;
        }
      }
    }

    if (!hasError) {
      if (channels.length > 0 && !priorityChannel) {
        priorityChannel = channels[0].id;
      }

      window.electronAPI.saveSettings({ channels, priorityChannel, obsSettings, verboseLogging, cookies });
      alert('Settings saved successfully!');
    }
  } catch (error) {
    console.error('Save error:', error);
    alert('Error saving settings: ' + error.message);
  } finally {
    saveBtn.disabled = false;
    saveBtn.textContent = 'Save Settings';
  }
});

async function getChannelIdFromDisplayName(displayName) {
  const username = displayName.replace(/^@/, ''); // Remove @ if present
  const url = `https://www.youtube.com/@${username}`;
  try {
    // Note: This fetch call will be blocked by CORS in a production build.
    // A proper solution would be to make this request from the main process.
    const response = await fetch(url);
    const html = await response.text();
    const match = html.match(/<link rel="canonical" href="https:\/\/www\.youtube\.com\/channel\/(UC[\w-]{22})">/);
    if (match) {
      return match[1];
    }
  } catch (error) {
    console.error('Error fetching channel page for display name:', error);
  }
  return null;
}

function isChannelId(str) {
  return /^UC[\w-]{22}$/.test(str);
}

window.electronAPI.getSettings().then((response) => {
  if (response.error) {
    console.error('Background script error:', response.error);
    populateSettings([], null, { host: 'localhost', port: '4455', password: '' }, false, '');
    return;
  }
  const { channels = [], priorityChannel = null, obsSettings = { host: 'localhost', port: '4455', password: '' }, verboseLogging = false, cookies = '' } = response;
  populateSettings(channels, priorityChannel, obsSettings, verboseLogging, cookies);
});

function populateSettings(channels, priorityChannel, obsSettings, verboseLogging, cookies) {
  const channelsContainer = document.getElementById('channels');
  channelsContainer.innerHTML = '';

  if (channels.length === 0) {
    addDefaultChannelInput();
  } else {
    channels.forEach(channel => {
      const div = document.createElement('div');
      div.className = 'channel-input';
      div.draggable = true;
      div.innerHTML = `
        <span class="drag-handle">☰</span>
        <input type="text" class="display-name" value="${channel.displayName}" placeholder="Display name">
        <input type="text" class="keywords" value="${channel.keywords || ''}" placeholder="Keywords (comma-separated)">
        <input type="hidden" class="channel-id" value="${channel.id}">
        <select class="obs-action">
          <option value="no-obs" ${channel.obsAction === 'no-obs' ? 'selected' : ''}>No OBS</option>
          <option value="stream" ${channel.obsAction === 'stream' ? 'selected' : ''}>Stream</option>
          <option value="record" ${channel.obsAction === 'record' ? 'selected' : ''}>Record</option>
        </select>
        <button class="remove">Remove</button>
      `;
      channelsContainer.appendChild(div);
    });
  }

  document.getElementById('obs-host').value = obsSettings.host || 'localhost';
  document.getElementById('obs-port').value = obsSettings.port || '4455';
  document.getElementById('obs-password').value = obsSettings.password || '';
  document.getElementById('verbose-logging').checked = verboseLogging || false;
  document.getElementById('cookies').value = cookies || '';
}

window.electronAPI.onUpdateLiveChannels((_event, liveChannels) => {
  const container = document.getElementById('live-channels');
  if (liveChannels.length === 0) {
    container.innerHTML = 'No channels are live.';
  } else {
    container.innerHTML = '';
    liveChannels.forEach(channel => {
      const button = document.createElement('button');
      button.textContent = `Watch ${channel.displayName}`;
      // In an Electron app, we would need to handle this differently,
      // for example, by opening the URL in the default browser.
      button.addEventListener('click', () => {
        // This will need to be implemented in the main process
        // to open a new window or the default browser.
        console.log(`Open channel: ${channel.displayName}`);
      });
      container.appendChild(button);
    });
  }
});

function addDefaultChannelInput() {
  const div = document.createElement('div');
  div.className = 'channel-input';
  div.draggable = true;
  div.innerHTML = `
    <span class="drag-handle">☰</span>
    <input type="text" class="display-name" placeholder="Display name">
    <input type="text" class="keywords" placeholder="Keywords (comma-separated)">
    <input type="hidden" class="channel-id" value="">
    <select class="obs-action">
      <option value="no-obs" selected>No OBS</option>
      <option value="stream">Stream</option>
      <option value="record">Record</option>
    </select>
    <button class="remove">Remove</button>
  `;
  document.getElementById('channels').appendChild(div);
}

// Check backend server status
async function checkBackendStatus() {
  const statusElement = document.getElementById('backend-status');
  try {
    const response = await fetch('http://localhost:5001/health', { timeout: 3000 });
    if (response.ok) {
      statusElement.textContent = '✓ Connected';
      statusElement.style.color = '#2ecc71';
    } else {
      statusElement.textContent = '✗ Error';
      statusElement.style.color = '#e74c3c';
    }
  } catch (error) {
    statusElement.textContent = '✗ Offline';
    statusElement.style.color = '#e74c3c';
  }
}

// Check backend status on load and periodically
checkBackendStatus();
setInterval(checkBackendStatus, 30000); // Check every 30 seconds

// Listen for analysis status updates from main process
window.electronAPI.onUpdateAnalysisStatus((_event, statusMessage) => {
  const statusElement = document.getElementById('analysis-status');
  if (statusElement) {
    statusElement.textContent = statusMessage;
    // Add timestamp
    const now = new Date().toLocaleTimeString();
    statusElement.title = `Last updated: ${now}`;
  }
});
