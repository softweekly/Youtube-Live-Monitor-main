# YouTube Live Monitor - Quick Start

## 🚀 Fastest Way to Get Started

### Prerequisites

You need these installed first:
- **Node.js** 22.x or later ([Download](https://nodejs.org/))
- **Python** 3.12+ ([Download](https://www.python.org/downloads/))
- **FFmpeg** ([Download](https://ffmpeg.org/download.html))

### Step 1: Install Dependencies

**Install Node.js packages:**
```bash
npm install
```

**Install Python packages:**
```bash
pip install -r requirements.txt
```

### Step 2: Launch the App

#### 🎯 Recommended: Minimal Stack

**Windows:**
```
Double-click: START_MINIMAL_STACK.bat
```

**Linux/Mac:**
```bash
chmod +x start-minimal-stack.sh
./start-minimal-stack.sh
```

This starts:
- ✅ Backend Analysis Server (Port 5001)
- ✅ Electron Desktop App

#### 🔧 Individual Services (Advanced)

**Start Backend Server:**
```bash
python backend.py
```

**Start Electron App:**
```bash
npm start
```

#### 🛑 Stop All Services

**Windows:**
```
Double-click: STOP_ALL_SERVICES.bat
```

**Linux/Mac:**
```bash
./stop-all-services.sh
```

## 📋 What This App Does

**YouTube Live Monitor** is a desktop application that:

- 📺 **Monitors YouTube channels** for live streams
- 🚀 **Auto-opens streams** when channels go live
- 🎬 **Controls OBS** to start recording/streaming automatically
- 🤖 **AI-powered analysis** using OpenAI Whisper for keyword detection
- 📊 **Real-time status** monitoring for all services
| **Combined Keyword** | Search channel videos | One-time analysis of existing videos |
| **Whisper GUI** | Download & transcribe videos | Batch processing, offline transcription |

## ⚙️ Quick Configuration

## ⚙️ Configuration

### 1. Configure the Electron App

1. **Add Channels**: Click "Add Channel", enter `@channelname` or full YouTube URL
2. **Add Keywords**: Enter `keyword1, keyword2, keyword3` (comma-separated)
3. **Set Priority Channel** (Optional): One channel checks faster
4. **Configure OBS** (Optional): For automatic recording/streaming
5. **Save Settings**

### 2. OBS Setup (Optional - For Auto Recording/Streaming)

1. Install OBS Studio and the WebSocket plugin
2. In OBS: `Tools → WebSocket Server Settings`
3. Enable server, note the port (usually 4455) and password
4. In the Electron app, click OBS settings and enter:
   - Host: `localhost`
   - Port: `4455`
   - Password: (your OBS password)
5. Save and the app will show OBS connection status

### 3. YouTube API Key (Optional - For Better Channel Detection)

1. Visit [Google Cloud Console](https://console.cloud.google.com/)
2. Create a project and enable YouTube Data API v3
3. Create an API key
4. In the Electron app settings, paste your API key

## 🎯 Example Usage

**Monitor a gaming channel for specific game mentions:**

1. Launch: `START_MINIMAL_STACK.bat`
2. Add channel: `@yourfavoritegamer`
3. Add keywords: `minecraft, fortnite, call of duty`
4. OBS Action: `Record` (if using OBS)
5. Save settings

**What happens:**
- ✅ App checks every 15 seconds for live streams
- ✅ When channel goes live, stream opens automatically
- ✅ OBS starts recording (if configured)
- ✅ Backend analyzes audio for your keywords
- ✅ Keywords logged with timestamps

## 🔍 Status Monitoring

The app displays real-time status indicators:

| Indicator | Meaning |
|-----------|---------|
| 🟢 Backend: Online | Analysis server ready |
| 🔴 Backend: Offline | Server not running |
| 🟢 OBS: Connected | Ready to record/stream |
| 🟡 OBS: Not Configured | Settings needed |
| ⏱️ Last Analysis | Most recent keyword check |

## ❓ Troubleshooting

**Backend shows offline:**
- Make sure `python backend.py` is running
- Wait 15-20 seconds for Whisper model to load
- Check `http://localhost:5001/health` in browser

**Channel not detected:**
- Verify channel handle (should be `@channelname`)
- Add YouTube API key for better detection
- Check if channel is actually live

**OBS won't connect:**
- Install OBS WebSocket plugin v5.x
- Enable server in OBS settings
- Verify host/port/password match

**Module not found errors:**
- Run `pip install -r requirements.txt`
- Make sure Python 3.12+ is installed

## 📖 Additional Documentation

- **`GEMINI.md`** - Complete project architecture and overview
- **`SETUP_GUIDE.md`** - Detailed installation and configuration
- **`TROUBLESHOOTING.md`** - Common issues and solutions
- **`ARCHITECTURE.md`** - Technical implementation details

## 🧪 Testing

Run the test suite to verify everything works:

**Windows:**
```
RUN_TESTS.bat
```

**Manual Testing:**
```bash
# Test backend
python backend.py
# In another terminal:
curl http://localhost:5001/health

# Test Electron
npm start
```

## 🎉 You're Ready!

Start monitoring YouTube channels and never miss a live stream again!
