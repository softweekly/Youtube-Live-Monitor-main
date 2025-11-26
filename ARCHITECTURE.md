# System Architecture & Data Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                     YouTube Live Monitor Suite                       │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                         COMPONENT 1                                  │
│                  Electron Desktop App                                │
│                    (Main Monitoring UI)                              │
├─────────────────────────────────────────────────────────────────────┤
│  • Port: Desktop Application                                         │
│  • Purpose: Real-time YouTube channel monitoring                     │
│  • Files: main.js, index.html, renderer.js, preload.js             │
│                                                                      │
│  Features:                                                           │
│  ✓ Monitor multiple channels (priority-based)                       │
│  ✓ Keyword detection in live streams                                │
│  ✓ OBS WebSocket integration                                        │
│  ✓ Status indicators (backend, OBS, analysis)                       │
│  ✓ Drag-and-drop channel ordering                                   │
│  ✓ Checks live status every 15 seconds                              │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
                    ┌───────────────────────┐
                    │  Triggers analysis on │
                    │  http://localhost:5001│
                    └───────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│                         COMPONENT 2                                  │
│                   Backend Analysis Server                            │
│                   (Flask REST API Server)                            │
├─────────────────────────────────────────────────────────────────────┤
│  • Port: 5001                                                        │
│  • Purpose: Video transcription & keyword analysis                   │
│  • File: backend.py                                                  │
│                                                                      │
│  Endpoints:                                                          │
│  GET  /health  → Health check for status monitoring                 │
│  POST /analyze → Transcribe video & search keywords                 │
│                                                                      │
│  Process Flow:                                                       │
│  1. Receive video URL + keywords                                     │
│  2. Download video (yt-dlp)                                          │
│  3. Extract audio (moviepy)                                          │
│  4. Transcribe with Whisper (OpenAI)                                │
│  5. Search keywords in transcript                                    │
│  6. Return matches with timestamps                                   │
│  7. Cleanup temp files                                               │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                         COMPONENT 3                                  │
│                  Combined Keyword Search                             │
│                  (Flask Web Application)                             │
├─────────────────────────────────────────────────────────────────────┤
│  • Port: 5000                                                        │
│  • Purpose: Search existing channel videos for keywords             │
│  • Files: Combined Keyword/app.py, website.html                     │
│                                                                      │
│  Features:                                                           │
│  ✓ Web UI for channel video search                                  │
│  ✓ YouTube Data API v3 integration                                  │
│  ✓ Transcript API for subtitle fetching                             │
│  ✓ Keyword frequency counting                                        │
│  ✓ Downloadable results file                                        │
│                                                                      │
│  Process Flow:                                                       │
│  1. User enters channel URL + keywords                               │
│  2. Fetch channel videos (YouTube API)                               │
│  3. Get transcripts (Transcript API)                                 │
│  4. Search keywords in transcripts                                   │
│  5. Generate results file                                            │
│  6. Return download link                                             │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                         COMPONENT 4                                  │
│                   Whisper Video Transcriber                          │
│                      (Tkinter GUI App)                               │
├─────────────────────────────────────────────────────────────────────┤
│  • Port: Desktop Application (GUI)                                   │
│  • Purpose: Download & transcribe YouTube channel videos             │
│  • Files: Whisper downloads/youtube_gui.py, youtube_channel_*.py   │
│                                                                      │
│  Features:                                                           │
│  ✓ Graphical interface for video transcription                      │
│  ✓ Batch processing of channel videos                               │
│  ✓ Filter by duration, date, live videos                            │
│  ✓ Multiple Whisper model sizes                                     │
│  ✓ Keyword search with timestamps                                   │
│  ✓ Export to TXT, CSV, JSON                                         │
│                                                                      │
│  Process Flow:                                                       │
│  1. User enters channel URL + settings                               │
│  2. Fetch channel videos (yt-dlp)                                    │
│  3. Filter videos by criteria                                        │
│  4. Download selected videos                                         │
│  5. Transcribe with Whisper                                          │
│  6. Search keywords in transcripts                                   │
│  7. Save results to output directory                                 │
└─────────────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════
                          DATA FLOW DIAGRAM
═══════════════════════════════════════════════════════════════════════

YouTube Live Stream
        │
        ↓
┌───────────────────┐
│  Electron App     │ ←─── User configures channels & keywords
│  Checks every     │
│  15 seconds       │
└─────────┬─────────┘
          │
          ├─── Channel goes live?
          │         │
          │         ↓ YES
          │    ┌─────────────────┐
          │    │ Trigger Actions │
          │    └────────┬────────┘
          │             │
          ├─────────────┼───────────────┐
          │             │               │
          ↓             ↓               ↓
    ┌─────────┐  ┌──────────┐   ┌──────────┐
    │ Open    │  │ Start    │   │ Send to  │
    │ Stream  │  │ OBS      │   │ Backend  │
    └─────────┘  │ Record   │   │ Server   │
                 └──────────┘   └─────┬────┘
                                      │
                                      ↓
                              ┌───────────────┐
                              │ Backend API   │
                              │ Port 5001     │
                              └───────┬───────┘
                                      │
                ┌─────────────────────┼─────────────────────┐
                ↓                     ↓                     ↓
        ┌───────────┐         ┌──────────┐        ┌────────────┐
        │ Download  │         │ Extract  │        │ Transcribe │
        │ Video     │    →    │ Audio    │   →    │ with       │
        │ (yt-dlp)  │         │(moviepy) │        │ Whisper    │
        └───────────┘         └──────────┘        └──────┬─────┘
                                                          │
                                                          ↓
                                                  ┌───────────────┐
                                                  │ Search        │
                                                  │ Keywords      │
                                                  └───────┬───────┘
                                                          │
                                                          ↓
                                                  ┌───────────────┐
                                                  │ Return        │
                                                  │ Matches +     │
                                                  │ Timestamps    │
                                                  └───────┬───────┘
                                                          │
                                                          ↓
                                                  ┌───────────────┐
                                                  │ Update UI     │
                                                  │ Status        │
                                                  └───────────────┘

═══════════════════════════════════════════════════════════════════════
                      FILE STRUCTURE OVERVIEW
═══════════════════════════════════════════════════════════════════════

Youtube-Live-Monitor-main/
│
├── 📄 QUICK_SETUP.bat              ← One-click setup verification
├── 📄 START_ELECTRON_APP.bat      ← Launch main monitoring app
├── 📄 START_BACKEND_SERVER.bat    ← Launch analysis server
├── 📄 START_COMBINED_KEYWORD.bat  ← Launch web search app
├── 📄 START_WHISPER_GUI.bat       ← Launch transcription GUI
│
├── 📘 README.md                    ← Quick start guide
├── 📘 SETUP_GUIDE.md              ← Comprehensive setup
├── 📘 UI_TESTING_CHECKLIST.md     ← Testing checklist
├── 📘 IMPROVEMENTS_SUMMARY.md     ← What was fixed
├── 📘 ARCHITECTURE.md             ← This file
│
├── 🎯 Electron App (Component 1)
│   ├── main.js                    ← Main process logic
│   ├── index.html                 ← UI layout
│   ├── renderer.js                ← UI interactions
│   ├── preload.js                 ← Bridge between main/renderer
│   ├── options.css                ← Styling
│   └── package.json               ← Dependencies
│
├── 🔧 Backend Server (Component 2)
│   └── backend.py                 ← Flask API server
│
├── 🔍 Combined Keyword/ (Component 3)
│   ├── app.py                     ← Flask web app
│   └── templates/
│       └── website.html           ← Web UI
│
└── 🎙️ Whisper downloads/ (Component 4)
    ├── youtube_gui.py             ← GUI application
    ├── youtube_channel_transcriber.py
    ├── video_transcriber.py
    ├── requirements.txt
    └── youtube_downloads/         ← Output directory

═══════════════════════════════════════════════════════════════════════
                       TECHNOLOGY STACK
═══════════════════════════════════════════════════════════════════════

Frontend Technologies:
  • Electron (Desktop App Framework)
  • HTML5 + CSS3 (UI)
  • JavaScript (UI Logic)
  • Tkinter (Python GUI)

Backend Technologies:
  • Node.js (Electron main process)
  • Python 3.8+ (Flask servers)
  • Flask (Web framework)

APIs & Services:
  • YouTube Data API v3 (Channel/video info)
  • YouTube Transcript API (Subtitle fetching)
  • OBS WebSocket (Broadcasting control)

AI/ML:
  • OpenAI Whisper (Speech-to-text)
  • Multiple model sizes (tiny → large)

Media Processing:
  • yt-dlp (YouTube downloading)
  • MoviePy (Video/audio processing)
  • FFmpeg (Media encoding)

Data Storage:
  • electron-store (Settings persistence)
  • JSON files (Results/transcripts)
  • File system (Videos/audio)

═══════════════════════════════════════════════════════════════════════
                        NETWORK PORTS
═══════════════════════════════════════════════════════════════════════

Port 5000:  Combined Keyword Search Web UI
Port 5001:  Backend Analysis API Server
Port 4455:  OBS WebSocket (configurable)

═══════════════════════════════════════════════════════════════════════
                    TYPICAL USER WORKFLOWS
═══════════════════════════════════════════════════════════════════════

Workflow 1: Auto-Record Live Streams
├─ 1. Start Backend Server (Port 5001)
├─ 2. Start Electron App
├─ 3. Configure channels + keywords
├─ 4. Configure OBS settings
├─ 5. Save settings
└─ 6. App monitors automatically
    ├─ Detects live streams
    ├─ Starts OBS recording
    ├─ Analyzes for keywords
    └─ Logs matches with timestamps

Workflow 2: Search Existing Videos
├─ 1. Configure YouTube API key
├─ 2. Start Combined Keyword app
├─ 3. Open browser to localhost:5000
├─ 4. Enter channel URL + keywords
├─ 5. Click "Run Analysis"
└─ 6. Download results file

Workflow 3: Batch Transcribe Videos
├─ 1. Start Whisper GUI
├─ 2. Enter channel URL
├─ 3. Configure filters (duration, count)
├─ 4. Set keywords to search
├─ 5. Choose model quality
├─ 6. Click "Start Processing"
└─ 7. Results saved to output directory

═══════════════════════════════════════════════════════════════════════
                       STATUS INDICATORS
═══════════════════════════════════════════════════════════════════════

Electron App Status Panel:
┌────────────────────────────────────────┐
│ Backend Server:    ✓ Connected (Green) │  ← Port 5001 reachable
│ OBS Connection:    ✗ Offline (Red)     │  ← WebSocket not configured
│ Last Analysis:     10:45:32 AM         │  ← Last keyword check
└────────────────────────────────────────┘

Status Updates:
  • Checked every 30 seconds (backend)
  • Real-time updates on analysis
  • Hover for timestamp details

═══════════════════════════════════════════════════════════════════════
                      ERROR HANDLING STRATEGY
═══════════════════════════════════════════════════════════════════════

All Components:
  ✓ Input validation before processing
  ✓ User-friendly error messages
  ✓ Graceful fallbacks on failure
  ✓ Console logging for debugging
  ✓ No crashes on invalid input

Electron App:
  • Channel ID resolution failures → Show error, don't crash
  • Backend offline → Display status, continue monitoring
  • OBS connection fails → Log error, continue other functions

Backend Server:
  • Invalid video URL → Return 400 error with message
  • Download fails → Return 500 error with reason
  • Transcription fails → Return 500 error with details

Combined Keyword:
  • Missing API key → Show configuration message
  • Invalid URL → Client-side validation
  • Network error → Show "check backend" message

═══════════════════════════════════════════════════════════════════════
                      PERFORMANCE CONSIDERATIONS
═══════════════════════════════════════════════════════════════════════

Electron App:
  • Check interval: 15 seconds (configurable)
  • Debounce: 30 seconds between actions
  • Minimal resource usage when idle

Backend Server:
  • Model size affects speed/accuracy tradeoff
  • Tiny model: ~5-10x realtime (fastest)
  • Base model: ~3-5x realtime (recommended)
  • Large model: ~1x realtime (best accuracy)
  • Auto cleanup temp files after processing

Whisper GUI:
  • Duration filter reduces processing time
  • Video count limit prevents overload
  • Live video priority for recent content

═══════════════════════════════════════════════════════════════════════
                         SECURITY NOTES
═══════════════════════════════════════════════════════════════════════

  • YouTube API keys stored in source (user configures)
  • OBS password stored in electron-store (encrypted)
  • YouTube cookies optional (for private videos)
  • No external network calls except YouTube/OBS
  • All processing done locally (no cloud services)
  • Temp files cleaned up after processing

═══════════════════════════════════════════════════════════════════════
                      EXTENSIBILITY POINTS
═══════════════════════════════════════════════════════════════════════

Easy to extend:
  • Add more channels (unlimited)
  • Change check interval (main.js line 30)
  • Adjust Whisper model (backend.py line 137)
  • Add custom OBS actions (main.js startObsStreaming)
  • Modify download quality (backend.py line 117)
  • Add new analysis endpoints (backend.py)

═══════════════════════════════════════════════════════════════════════
