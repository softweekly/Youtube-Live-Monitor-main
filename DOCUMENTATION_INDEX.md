# 📖 Documentation Index

Welcome to the YouTube Live Monitor Suite! This document helps you find what you need quickly.

## 🚀 Getting Started (Start Here!)

| Document | Purpose | When to Use |
|----------|---------|-------------|
| **[README.md](README.md)** | Quick start guide | First time setup - read this first! |
| **[QUICK_SETUP.bat](QUICK_SETUP.bat)** | Setup verification script | Run this to check if everything is ready |

## 🎯 Running the Applications

### Stack Launchers (All-in-One)

| Script | Platform | Launches | Description |
|--------|----------|----------|-------------|
| **[START_ALL_SERVICES.bat](START_ALL_SERVICES.bat)** | Windows | All 3 services | Full stack with all components |
| **[start-all-services.sh](start-all-services.sh)** | Linux/Mac | All 3 services | Full stack with all components |
| **[START_MINIMAL_STACK.bat](START_MINIMAL_STACK.bat)** | Windows | Backend + Electron | Essential services only |
| **[start-minimal-stack.sh](start-minimal-stack.sh)** | Linux/Mac | Backend + Electron | Essential services only |
| **[STOP_ALL_SERVICES.bat](STOP_ALL_SERVICES.bat)** | Windows | - | Stop all running services |
| **[stop-all-services.sh](stop-all-services.sh)** | Linux/Mac | - | Stop all running services |

### Individual Service Launchers

| Script | Platform | Launches | Port/Type |
|--------|----------|----------|-----------|
| **[START_ELECTRON_APP.bat](START_ELECTRON_APP.bat)** | Windows | Main monitoring app | Desktop App |
| **[START_BACKEND_SERVER.bat](START_BACKEND_SERVER.bat)** | Windows | Analysis backend | Port 5001 |
| **[START_COMBINED_KEYWORD.bat](START_COMBINED_KEYWORD.bat)** | Windows | Keyword search web app | Port 5000 |
| **[START_WHISPER_GUI.bat](START_WHISPER_GUI.bat)** | Windows | Video transcription GUI | Desktop App |

## 📚 Detailed Documentation

### Setup & Configuration
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Comprehensive setup instructions with:
  - Prerequisites checklist
  - Step-by-step installation
  - Configuration examples
  - Performance tips
  - Workflow examples

- **[STACK_LAUNCHER_GUIDE.md](STACK_LAUNCHER_GUIDE.md)** - Stack launcher documentation with:
  - Full vs Minimal stack comparison
  - Platform-specific instructions (Windows/Linux/Mac)
  - Troubleshooting stack launchers
  - Resource usage optimization
  - Log file management

### System Understanding
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System architecture with:
  - Component diagrams
  - Data flow visualization
  - Technology stack
  - Network ports
  - File structure

### Testing & Quality
- **[UI_TESTING_CHECKLIST.md](UI_TESTING_CHECKLIST.md)** - Complete testing guide with:
  - 100+ test cases
  - Component-specific tests
  - Integration tests
  - Error recovery tests

### Problem Solving
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Quick problem resolution:
  - Common issues & solutions
  - Error message meanings
  - Diagnostic commands
  - Prevention tips

### Development
- **[IMPROVEMENTS_SUMMARY.md](IMPROVEMENTS_SUMMARY.md)** - What was changed:
  - Features added
  - Bugs fixed
  - Files modified
  - Verification steps

## 🎓 Learning Path

### For First-Time Users
1. Read **[README.md](README.md)** (5 minutes)
2. Run **[QUICK_SETUP.bat](QUICK_SETUP.bat)** (2 minutes)
3. Pick a tool and run its START script (1 minute)
4. Follow the UI to configure (5 minutes)
5. Refer to **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** if needed

### For Advanced Users
1. Review **[ARCHITECTURE.md](ARCHITECTURE.md)** to understand system design
2. Check **[SETUP_GUIDE.md](SETUP_GUIDE.md)** for advanced configuration
3. Use **[UI_TESTING_CHECKLIST.md](UI_TESTING_CHECKLIST.md)** for comprehensive testing
4. Read **[IMPROVEMENTS_SUMMARY.md](IMPROVEMENTS_SUMMARY.md)** to see what's new

### For Developers
1. Study **[ARCHITECTURE.md](ARCHITECTURE.md)** for system overview
2. Review code files with comments
3. Check **[IMPROVEMENTS_SUMMARY.md](IMPROVEMENTS_SUMMARY.md)** for recent changes
4. Use **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** for debugging

## 📁 File Reference

### Application Files
```
📦 Core Application
├── 📄 main.js              - Electron main process
├── 📄 index.html           - UI layout
├── 📄 renderer.js          - UI interactions
├── 📄 preload.js           - IPC bridge
├── 📄 options.css          - Styling
├── 📄 backend.py           - Analysis server
└── 📄 package.json         - Node dependencies

📦 Combined Keyword Search
└── Combined Keyword/
    ├── 📄 app.py           - Flask web app
    └── templates/
        └── 📄 website.html - Web UI

📦 Whisper Transcription
└── Whisper downloads/
    ├── 📄 youtube_gui.py   - GUI application
    └── 📄 requirements.txt - Python dependencies
```

### Documentation Files
```
📚 Documentation
├── 📘 README.md                   - Quick start
├── 📘 SETUP_GUIDE.md              - Detailed setup
├── 📘 STACK_LAUNCHER_GUIDE.md     - Stack launcher guide
├── 📘 ARCHITECTURE.md             - System design
├── 📘 TROUBLESHOOTING.md          - Problem solving
├── 📘 UI_TESTING_CHECKLIST.md     - Testing guide
├── 📘 IMPROVEMENTS_SUMMARY.md     - What's new
└── 📘 DOCUMENTATION_INDEX.md      - This file

🚀 Startup Scripts
├── 📄 QUICK_SETUP.bat             - Setup verification
├── 📄 START_ALL_SERVICES.bat      - Full stack (Windows)
├── 📄 START_MINIMAL_STACK.bat     - Minimal stack (Windows)
├── 📄 STOP_ALL_SERVICES.bat       - Stop all (Windows)
├── 📄 start-all-services.sh       - Full stack (Linux/Mac)
├── 📄 start-minimal-stack.sh      - Minimal stack (Linux/Mac)
├── 📄 stop-all-services.sh        - Stop all (Linux/Mac)
├── 📄 START_ELECTRON_APP.bat      - Individual: Electron
├── 📄 START_BACKEND_SERVER.bat    - Individual: Backend
├── 📄 START_COMBINED_KEYWORD.bat  - Individual: Web app
└── 📄 START_WHISPER_GUI.bat       - Individual: Whisper GUI
```

## 🔍 Quick Reference

### Common Tasks

| I want to... | Read this | Run this |
|--------------|-----------|----------|
| Get started quickly | [README.md](README.md) | [QUICK_SETUP.bat](QUICK_SETUP.bat) |
| Start all services | [STACK_LAUNCHER_GUIDE.md](STACK_LAUNCHER_GUIDE.md) | Windows: [START_ALL_SERVICES.bat](START_ALL_SERVICES.bat)<br>Linux: `./start-all-services.sh` |
| Start minimal stack | [STACK_LAUNCHER_GUIDE.md](STACK_LAUNCHER_GUIDE.md) | Windows: [START_MINIMAL_STACK.bat](START_MINIMAL_STACK.bat)<br>Linux: `./start-minimal-stack.sh` |
| Stop all services | [STACK_LAUNCHER_GUIDE.md](STACK_LAUNCHER_GUIDE.md) | Windows: [STOP_ALL_SERVICES.bat](STOP_ALL_SERVICES.bat)<br>Linux: `./stop-all-services.sh` |
| Monitor live streams | [README.md](README.md) | [START_MINIMAL_STACK.bat](START_MINIMAL_STACK.bat) |
| Search existing videos | [SETUP_GUIDE.md](SETUP_GUIDE.md) | [START_COMBINED_KEYWORD.bat](START_COMBINED_KEYWORD.bat) |
| Transcribe videos | [SETUP_GUIDE.md](SETUP_GUIDE.md) | [START_WHISPER_GUI.bat](START_WHISPER_GUI.bat) |
| Configure OBS | [SETUP_GUIDE.md](SETUP_GUIDE.md) §OBS Settings | - |
| Fix problems | [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | - |
| Test everything | [UI_TESTING_CHECKLIST.md](UI_TESTING_CHECKLIST.md) | - |
| Understand system | [ARCHITECTURE.md](ARCHITECTURE.md) | - |
| See what's new | [IMPROVEMENTS_SUMMARY.md](IMPROVEMENTS_SUMMARY.md) | - |

### Configuration Files

| Setting | Location | Line |
|---------|----------|------|
| YouTube API Key | `Combined Keyword/app.py` | Line 11 |
| Backend Port | `backend.py` | Line 183 |
| Combined Keyword Port | `Combined Keyword/app.py` | Last line |
| Check Interval | `main.js` | Line 30 |
| Whisper Model Size | `backend.py` | Line 137 |
| Download Quality | `backend.py` | Line 117 |

### Important URLs

| Service | URL | Purpose |
|---------|-----|---------|
| Backend Health | http://localhost:5001/health | Check if backend is running |
| Backend API | http://localhost:5001/analyze | Video analysis endpoint |
| Combined Keyword | http://localhost:5000 | Web-based keyword search |
| YouTube API Console | https://console.cloud.google.com/ | Get API key |
| OBS WebSocket | https://github.com/obsproject/obs-websocket | OBS plugin |

## 🆘 Help! I'm Stuck

### Quick Troubleshooting Sequence

1. **Check Prerequisites**
   - Run [QUICK_SETUP.bat](QUICK_SETUP.bat)
   - Verify Node.js, Python, FFmpeg installed

2. **Common Issues**
   - Backend offline? → Run [START_BACKEND_SERVER.bat](START_BACKEND_SERVER.bat)
   - Channel not found? → See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) §Channel ID
   - OBS won't connect? → See [SETUP_GUIDE.md](SETUP_GUIDE.md) §OBS Settings
   - API errors? → See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) §API Key

3. **Still Stuck?**
   - Read [TROUBLESHOOTING.md](TROUBLESHOOTING.md) fully
   - Enable verbose logging in Electron app
   - Check console output in all terminal windows
   - Review [ARCHITECTURE.md](ARCHITECTURE.md) to understand system

## 📊 Documentation Statistics

- **Total Documentation Files**: 8
- **Total Startup Scripts**: 11 (6 stack + 5 individual)
- **Platform Support**: Windows, Linux, Mac
- **Test Cases**: 100+
- **Troubleshooting Scenarios**: 15+
- **Example Workflows**: 3
- **Configuration Options**: 10+

## 🔄 Document Update Status

All documentation current as of: **November 26, 2025**

Last updated by: **AI Assistant**

## 💡 Tips for Reading Documentation

- **Ctrl+F** to search within documents
- Documents link to each other - follow the links!
- Start with README, expand to other docs as needed
- Batch files are self-documenting (read the echo messages)
- Code files have inline comments for complex sections

## 🎯 Next Steps

1. ✅ You're reading this index - good start!
2. ✅ Go to [README.md](README.md) for quick start
3. ✅ Run [QUICK_SETUP.bat](QUICK_SETUP.bat) to verify setup
4. ✅ Choose a component and launch it
5. ✅ Refer back to docs as needed

Happy monitoring! 🚀
