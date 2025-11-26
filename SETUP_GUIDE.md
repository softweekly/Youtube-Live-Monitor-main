# YouTube Live Monitor & Analysis Suite - Setup Guide

This guide will help you set up and run all three tools in this suite.

## Prerequisites

Before you begin, make sure you have:

1. **Node.js** (v16 or higher) - [Download here](https://nodejs.org/)
2. **Python** (3.8 or higher) - [Download here](https://python.org/)
3. **FFmpeg** - Required for video processing
   - Download from [ffmpeg.org](https://ffmpeg.org/download.html)
   - Add to your system PATH
4. **YouTube Data API Key** (only for Combined Keyword Search)
   - Get one at [Google Cloud Console](https://console.cloud.google.com/)

## Quick Start

### 1. Install Electron App Dependencies

**Windows:**
```bash
cd "Youtube-Live-Monitor-main"
npm install
```

**Linux/Mac:**
```bash
cd Youtube-Live-Monitor-main
npm install
chmod +x *.sh  # Make shell scripts executable
```

### 2. Configure YouTube Data API (Optional - only for Combined Keyword Search)

Edit `Combined Keyword\app.py` and replace:
```python
API_KEY = "YOUR_API_KEY_HERE"
```
with your actual YouTube Data API key.

### 3. Run the Applications

#### Quick Launch (All Services)

**Windows:**
```
Double-click: START_ALL_SERVICES.bat      (Full stack)
    OR
Double-click: START_MINIMAL_STACK.bat     (Backend + Electron only)
```

**Linux/Mac:**
```bash
./start-all-services.sh       # Full stack
    OR
./start-minimal-stack.sh      # Minimal stack
```

#### Individual Services

#### Option A: YouTube Live Monitor (Electron Desktop App)
Double-click: `START_ELECTRON_APP.bat`
- Monitor multiple YouTube channels for live streams
- Automatically trigger OBS recording/streaming
- Keyword analysis integration

#### Option B: Backend Analysis Server (Required for Electron App features)
Double-click: `START_BACKEND_SERVER.bat`
- Runs on port 5001
- Handles video transcription and keyword matching
- Keep this running when using the Electron app

#### Option C: Combined Keyword Search (Web Interface)
Double-click: `START_COMBINED_KEYWORD.bat`
- Runs on port 5000
- Search YouTube channels for keywords in transcripts
- Open browser to http://localhost:5000

#### Option D: Whisper Video Transcriber (GUI)
Double-click: `START_WHISPER_GUI.bat`
- Standalone GUI for video transcription
- Download and transcribe YouTube videos
- Batch processing capabilities

## Configuration

### Electron App Setup

1. Launch the app using `START_ELECTRON_APP.bat`
2. Configure your channels:
   - Click "Add Channel"
   - Enter channel name (e.g., `@channelname` or display name)
   - Add keywords (comma-separated) for monitoring
   - Choose OBS action (No OBS, Stream, or Record)
   - Drag channels to reorder priority

3. Configure OBS Settings (if using OBS integration):
   - Host: `localhost` (default)
   - Port: `4455` (OBS WebSocket default)
   - Password: Your OBS WebSocket password
   - *Note: Install and enable OBS WebSocket plugin*

4. Optional Settings:
   - Enable verbose logging for debugging
   - Add YouTube cookies for private/age-restricted content

5. Click "Save Settings"

### Backend Server

The backend server automatically starts on port 5001. No configuration needed unless you want to change:
- Model size (currently set to "tiny" for speed - edit `backend.py` line 137)
- Download directory (automatically uses `temp_video_downloads`)

### Combined Keyword Search

1. Get YouTube Data API key from Google Cloud Console
2. Edit `Combined Keyword\app.py` 
3. Replace `YOUR_API_KEY_HERE` with your key
4. Run `START_COMBINED_KEYWORD.bat`
5. Open http://localhost:5000 in your browser

### Whisper GUI

No configuration needed! Just:
1. Run `START_WHISPER_GUI.bat`
2. The GUI will open automatically
3. Configure settings in the interface

## System Status Indicators

The Electron app now shows real-time status:

- **Backend Server**: Shows if analysis backend (port 5001) is running
- **OBS Connection**: Shows OBS WebSocket connection status  
- **Last Analysis**: Shows when keyword analysis last ran

## Typical Usage Workflows

### Workflow 1: Auto-Record Live Streams with Keyword Monitoring

1. Start Backend Server: `START_BACKEND_SERVER.bat`
2. Start Electron App: `START_ELECTRON_APP.bat`
3. Configure OBS WebSocket (install OBS WebSocket plugin first)
4. Add channels with keywords you want to monitor
5. Set OBS action to "Record" or "Stream"
6. The app will:
   - Check every 15 seconds if channels are live
   - Automatically start OBS recording when live
   - Analyze video for your keywords
   - Log keyword matches with timestamps

### Workflow 2: Search Existing Videos for Keywords

1. Start Combined Keyword: `START_COMBINED_KEYWORD.bat`
2. Open browser to http://localhost:5000
3. Enter YouTube channel URL
4. Enter keywords (comma-separated)
5. Click "Run Analysis"
6. Download results file with keyword matches

### Workflow 3: Download & Transcribe Channel Videos

1. Start Whisper GUI: `START_WHISPER_GUI.bat`
2. Enter YouTube channel URL
3. Enter keywords to search for
4. Configure settings:
   - Max videos to process
   - Max duration (filters long videos)
   - Model quality (base recommended)
5. Click "Start Processing"
6. Results saved to output directory

## Troubleshooting

### Backend Server Issues

**Problem**: "Backend Server: ✗ Offline" in Electron app

**Solutions**:
- Make sure `START_BACKEND_SERVER.bat` is running
- Check if port 5001 is already in use
- Look for Python errors in the backend console window

### OBS Connection Issues

**Problem**: OBS won't connect

**Solutions**:
- Install OBS WebSocket plugin (Tools → WebSocket Server Settings)
- Enable WebSocket server in OBS
- Verify port (default 4455) and password match your settings
- Check that OBS is running before starting the Electron app

### Channel ID Resolution Fails

**Problem**: "Could not find channel ID for @channelname"

**Solutions**:
- Try using the full channel URL instead
- Check if channel name is spelled correctly
- For personal channels, try: `youtube.com/channel/UC...` format
- Use channel ID directly (starts with "UC")

### Video Download Errors

**Problem**: Videos won't download in Whisper GUI

**Solutions**:
- Install FFmpeg and add to PATH
- Check internet connection
- Verify YouTube URL is correct
- Some videos may be restricted (try adding cookies)

### Transcription Slow or Fails

**Problem**: Whisper transcription takes too long or crashes

**Solutions**:
- Use smaller model (tiny or base)
- Filter videos by duration (e.g., max 30 minutes)
- Ensure you have enough disk space
- For GPU acceleration: Install CUDA toolkit

### API Key Errors (Combined Keyword Search)

**Problem**: "Invalid API key" or quota errors

**Solutions**:
- Verify API key is correct in `app.py`
- Enable YouTube Data API v3 in Google Cloud Console
- Check API quota (free tier has daily limits)
- Wait 24 hours if quota exceeded

## Performance Tips

### For Faster Processing:
- Use "tiny" or "base" Whisper models
- Limit max video duration (30 min recommended)
- Process fewer videos at once (5-10)
- Close unnecessary applications

### For Better Accuracy:
- Use "medium" or "large" Whisper models (slower)
- Ensure good internet connection
- Use higher quality video downloads

### For System Monitoring:
- Enable verbose logging in Electron app
- Check console logs in backend/Combined Keyword windows
- Monitor system resources (CPU, RAM, disk)

## File Locations

- **Electron App Settings**: Stored in Electron-store (automatic)
- **Downloaded Videos**: `temp_video_downloads/` (auto-cleaned)
- **Whisper Output**: `Whisper downloads/youtube_downloads/`
- **Combined Keyword Results**: `~/Desktop/YouTube_Keyword_Search/`
- **Logs**: Console windows for each service

## Need Help?

If you encounter issues:

1. Enable verbose logging in Electron app
2. Check console output in all running services
3. Verify all prerequisites are installed
4. Try restarting services
5. Check port conflicts (5000, 5001)

## Advanced Configuration

### Change Backend Model Quality

Edit `backend.py` line 137:
```python
transcriber = VideoTranscriber(model_size="tiny")  # Change to: base, small, medium, large
```

### Change Check Interval (Electron App)

Edit `main.js` line 30:
```javascript
setInterval(checkLiveStatus, 15 * 1000); // Change 15 to desired seconds
```

### Customize Download Quality

Edit `backend.py` line 117:
```python
'format': 'best[height<=480]', # Change to: best, best[height<=720], etc.
```

## What's Next?

- Explore the different UIs
- Customize settings for your workflow
- Set up OBS automation for your streams
- Build your keyword dictionary for monitoring

Enjoy your YouTube monitoring and analysis suite!
