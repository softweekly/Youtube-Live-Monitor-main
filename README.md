# YouTube Live Monitor Suite - Quick Start

## 🚀 Fastest Way to Get Started

### Step 1: Run Setup (One Time Only)

**Windows:**
```
Double-click: QUICK_SETUP.bat
```

**Linux/Mac:**
```bash
chmod +x *.sh
# Check prerequisites manually: python3, node, npm, ffmpeg
```

### Step 2: Launch Services

#### 🎯 Quick Stack Launch (Recommended)

**Windows - Full Stack:**
```
Double-click: START_ALL_SERVICES.bat
```
Starts: Backend + Combined Keyword + Electron (all 3 services)

**Windows - Minimal Stack:**
```
Double-click: START_MINIMAL_STACK.bat
```
Starts: Backend + Electron (essential services only)

**Linux/Mac - Full Stack:**
```bash
./start-all-services.sh
```

**Linux/Mac - Minimal Stack:**
```bash
./start-minimal-stack.sh
```

#### 🔧 Individual Services (Advanced)

**Windows:**
- **`START_BACKEND_SERVER.bat`** - Analysis backend (port 5001)
- **`START_ELECTRON_APP.bat`** - Main monitoring app
- **`START_COMBINED_KEYWORD.bat`** - Web keyword search (port 5000)
- **`START_WHISPER_GUI.bat`** - Video transcription GUI

**Linux/Mac:**
```bash
# Individual services (create wrapper scripts or run directly)
python3 backend.py              # Backend server
npm start                       # Electron app
cd "Combined Keyword" && python3 app.py    # Web search
python3 "Whisper downloads/youtube_gui.py" # GUI
```

#### 🛑 Stop All Services

**Windows:**
```
Double-click: STOP_ALL_SERVICES.bat
```

**Linux/Mac:**
```bash
./stop-all-services.sh
    OR
Press Ctrl+C in the terminal running the services
```

## 📋 What Each Tool Does

| Tool | Purpose | Best For |
|------|---------|----------|
| **Electron App** | Monitor channels for live streams | Real-time monitoring, OBS automation |
| **Backend Server** | Analyze videos for keywords | Powers the Electron app |
| **Combined Keyword** | Search channel videos | One-time analysis of existing videos |
| **Whisper GUI** | Download & transcribe videos | Batch processing, offline transcription |

## ⚙️ Quick Configuration

### Electron App
1. **Add Channel**: Click "Add Channel", enter `@channelname`
2. **Add Keywords**: Enter `keyword1, keyword2, keyword3`
3. **Set OBS Action**: Choose Stream/Record if using OBS
4. **Save**: Click "Save Settings"

### OBS Setup (Optional)
1. Install OBS WebSocket plugin
2. In OBS: Tools → WebSocket Server Settings
3. Enable server, note port and password
4. Enter in Electron app OBS Settings

### Combined Keyword (One-Time Setup)
1. Get API key: https://console.cloud.google.com/
2. Enable YouTube Data API v3
3. Copy key to `Combined Keyword\app.py` line 11

## 🎯 Example Workflow

**Monitor NASA for rocket launch mentions:**
1. Start backend: `START_BACKEND_SERVER.bat`
2. Start app: `START_ELECTRON_APP.bat`
3. Add channel: `@NASA`
4. Add keywords: `launch, rocket, countdown, liftoff`
5. OBS Action: `Record`
6. Save settings

Now when NASA goes live and mentions "launch" or "rocket", the app will:
- Detect the live stream automatically
- Start recording in OBS
- Analyze the stream for your keywords
- Log keyword matches with timestamps

## 🔍 System Status

The Electron app shows real-time status:
- **Backend Server**: ✓ Connected / ✗ Offline
- **OBS Connection**: ✓ Connected / ✗ Not configured
- **Last Analysis**: Timestamp of last keyword check

## ❓ Common Issues

**Backend shows offline**: Make sure `START_BACKEND_SERVER.bat` is running

**Channel ID not found**: Try full URL: `https://youtube.com/@channelname`

**OBS won't connect**: Install OBS WebSocket plugin and enable it

**API quota exceeded**: YouTube API has daily limits, wait 24 hours

## 📖 Full Documentation

See **`SETUP_GUIDE.md`** for:
- Detailed setup instructions
- Advanced configuration
- Troubleshooting guide
- Performance tips

See **`UI_TESTING_CHECKLIST.md`** to verify everything works.

## 🎉 You're Ready!

Pick a tool above and start monitoring YouTube channels for your keywords!
