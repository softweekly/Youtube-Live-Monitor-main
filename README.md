# YouTube Live Monitor - Quick Start

## 🚀 ONE-CLICK STARTUP (Recommended)

### Windows
```
Double-click: QUICK_START.bat
```

### Linux/Mac
```bash
chmod +x quick-start.sh
./quick-start.sh
```

**What it does automatically:**
- ✅ Creates Python virtual environment (if needed)
- ✅ Installs all Node.js dependencies (if needed)
- ✅ Installs all Python dependencies
- ✅ Starts backend server
- ✅ Starts Electron app

**Just double-click and go!** 🎉

---

## 📋 Prerequisites

You only need these installed first:
- **Node.js** 22.x or later ([Download](https://nodejs.org/))
- **Python** 3.12+ ([Download](https://www.python.org/downloads/))
- **FFmpeg** ([Download](https://ffmpeg.org/download.html))

---

## ⚙️ Manual Setup (Advanced Users)

### Install Dependencies

**Install Node.js packages:**
```bash
npm install
```

**Install Python packages:**
```bash
python -m venv .venv
.venv\Scripts\activate  # Windows
source .venv/bin/activate  # Linux/Mac
pip install -r requirements.txt
```

### Step 2: Launch the App

#### 🎯 Quick Start Scripts

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

- 📺 **Monitors YouTube channels** for live streams (checks every 15 seconds)
- 💾 **Auto-downloads streams** when channels go live (saved to `live_stream_recordings/`)
- 🔐 **Supports member-only streams** via cookie authentication
- 🎬 **Controls OBS** to start recording/streaming automatically (optional)
- 🤖 **AI-powered keyword detection** using OpenAI Whisper for transcription
- 📊 **Real-time status** monitoring for all services
- ⚡ **Instant recording** - starts downloading as soon as stream begins
| **Combined Keyword** | Search channel videos | One-time analysis of existing videos |
| **Whisper GUI** | Download & transcribe videos | Batch processing, offline transcription |

## ⚙️ Quick Configuration

## ⚙️ Configuration

### 1. Configure the Electron App

1. **Add Channels**: Click "Add Channel", enter `@channelname` or full YouTube URL
2. **Add Keywords**: Enter `keyword1, keyword2, keyword3` (comma-separated)
3. **Set Priority Channel** (Optional): One channel checks faster
4. **Add Cookies** (For Member-Only Streams): Paste your YouTube cookies
5. **Configure OBS** (Optional): For automatic recording/streaming
6. **Save Settings**

### 2. Setup Cookies for Member-Only Streams

**Why Cookies?** If you want to download member-only or subscriber-only live streams, you need to provide your YouTube session cookies.

**How to Get Cookies:**
1. Install a browser extension like "Get cookies.txt LOCALLY"
2. Go to YouTube.com and make sure you're logged in
3. Use the extension to export your cookies
4. Copy the cookie text
5. Paste it into the "YouTube Cookies" field in the app
6. Save settings

**Important:** Keep your cookies private! They give access to your YouTube account.

### 3. OBS Setup (Optional - For Auto Recording/Streaming)

1. Install OBS Studio and the WebSocket plugin
2. In OBS: `Tools → WebSocket Server Settings`
3. Enable server, note the port (usually 4455) and password
4. In the Electron app, click OBS settings and enter:
   - Host: `localhost`
   - Port: `4455`
   - Password: (your OBS password)
5. Save and the app will show OBS connection status

### 4. YouTube API Key (Optional - For Better Channel Detection)

1. Visit [Google Cloud Console](https://console.cloud.google.com/)
2. Create a project and enable YouTube Data API v3
3. Create an API key
4. In the Electron app settings, paste your API key

## 🎯 Example Usage

**Monitor a gaming channel and auto-download member-only streams:**

1. Launch: `START_MINIMAL_STACK.bat`
2. Add your YouTube cookies (if member-only content)
3. Add channel: `@yourfavoritegamer`
4. Add keywords: `minecraft, fortnite, call of duty`
5. OBS Action: `Record` (if using OBS)
6. Save settings

**What happens:**
- ✅ App checks every 15 seconds for live streams
- ✅ **Downloads start immediately** when channel goes live
- ✅ Videos saved to `live_stream_recordings/` folder
- ✅ OBS starts recording (if configured)
- ✅ Backend analyzes audio for your keywords
- ✅ Keywords logged with timestamps

**Where are my downloads?**
All live stream recordings are saved to: `./live_stream_recordings/`

## 🔍 Status Monitoring

The app displays real-time status indicators:

| Indicator | Meaning |
|-----------|---------|
| 🟢 Backend: Online | Analysis server ready |
| 🔴 Backend: Offline | Server not running |
| 🟢 OBS: Connected | Ready to record/stream |
| 🟡 OBS: Not Configured | Settings needed |
| 📹 Recording Status | Current download/analysis activity |
| 📁 Downloads Saved | Location of recorded streams |

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
