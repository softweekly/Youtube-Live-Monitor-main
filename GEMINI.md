# YouTube Live Monitor - Project Overview

An Electron desktop application that monitors YouTube channels for live streams, automatically opens them, and optionally controls OBS (Open Broadcaster Software) for streaming/recording. Includes AI-powered video analysis using OpenAI Whisper for keyword detection in live content.

## Key Technologies

### Frontend (Electron App)
- **Platform:** Electron Desktop Application
- **Languages:** JavaScript, HTML, CSS
- **Key Libraries:**
  - `electron` - Desktop app framework
  - `electron-store` - Settings persistence
  - `node-fetch` - HTTP requests
  - `ws` - WebSocket client for OBS communication

### Backend (Python Flask)
- **Platform:** Flask REST API Server
- **Languages:** Python 3.12+
- **Key Libraries:**
  - `Flask` - Web framework
  - `openai-whisper` - AI speech-to-text transcription
  - `yt-dlp` - YouTube video downloading
  - `moviepy` - Video/audio processing
  - `numpy`, `torch` - ML dependencies

## Architecture

### Core Components

1. **main.js** - Electron main process
   - Manages app lifecycle
   - Monitors YouTube channels for live streams
   - Controls OBS via WebSocket
   - Triggers keyword analysis via backend API

2. **renderer.js** - Electron renderer process
   - UI interactions and updates
   - Settings management
   - Status indicators (Backend, OBS, Analysis)
   - Error handling and user feedback

3. **backend.py** - Flask API server (Port 5001)
   - `/health` - Server health check
   - `/analyze` - Video analysis endpoint
   - Whisper-based transcription
   - Keyword detection in video content

4. **index.html** - UI layout
   - Channel configuration
   - OBS settings
   - Real-time status monitoring

### Communication Flow

```
User → Electron UI → main.js → Backend API (Flask)
                  ↓
                OBS via WebSocket
```

## Setup Instructions

### Prerequisites
- Node.js 22.x or later
- Python 3.12 or later
- FFmpeg (for video/audio processing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/softweekly/Combined-Keyword.git
   cd Youtube-Live-Monitor-main
   ```

2. **Install Node.js dependencies**
   ```bash
   npm install
   ```

3. **Install Python dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure YouTube API** (optional but recommended)
   - Get API key from Google Cloud Console
   - Enable YouTube Data API v3
   - Add to settings in the app

### Running the Application

#### Option 1: Quick Start (All Services)
```bash
# Windows
START_ALL_SERVICES.bat

# Linux/Mac
./start-all-services.sh
```

#### Option 2: Minimal Stack (Backend + Electron only)
```bash
# Windows
START_MINIMAL_STACK.bat

# Linux/Mac
./start-minimal-stack.sh
```

#### Option 3: Manual Start

**Start Backend Server:**
```bash
python backend.py
```
Backend runs on http://localhost:5001

**Start Electron App:**
```bash
npm start
```

### Configuration

1. Open the application
2. Click the settings/options button
3. Configure:
   - YouTube channels to monitor
   - YouTube API key (optional)
   - OBS connection settings (host, port, password)
   - Priority channel (gets checked more frequently)
   - Verbose logging (for debugging)

## Features

### Live Stream Monitoring
- Monitors multiple YouTube channels simultaneously
- Priority channel with faster check intervals
- Automatic stream opening when channel goes live
- Configurable polling intervals

### OBS Integration
- WebSocket-based control
- Automatic stream/recording start on live detection
- Configurable connection settings
- Real-time connection status

### Video Analysis (AI-Powered)
- Whisper-based transcription
- Keyword detection in live streams
- Audio extraction from videos
- Configurable analysis triggers

### Status Monitoring
- Backend server health indicator
- OBS connection status
- Last analysis timestamp
- Real-time updates

## Development Conventions

### Code Style
- JavaScript: Standard conventions, async/await for promises
- Python: PEP 8 style guidelines
- Comprehensive error handling with user-friendly messages

### Project Structure
```
Youtube-Live-Monitor-main/
├── main.js              # Electron main process
├── renderer.js          # UI logic
├── preload.js          # IPC bridge
├── index.html          # Main UI
├── options.css         # Styling
├── backend.py          # Flask API server
├── package.json        # Node dependencies
├── requirements.txt    # Python dependencies
├── START_*.bat         # Windows launchers
├── start-*.sh          # Linux/Mac launchers
└── docs/               # Documentation
```

### Testing
Run the comprehensive test suite:
```bash
# Windows
RUN_TESTS.bat

# Linux/Mac
./run-tests.sh
```

## Troubleshooting

Common issues and solutions documented in `TROUBLESHOOTING.md`:
- Dependency installation problems
- Backend server startup issues
- OBS connection failures
- Video analysis errors

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly using RUN_TESTS
5. Submit a pull request

## License

ISC License

## Author

Built with ❤️ for YouTube content creators and stream managers
