# Stack Launcher Guide

## Overview

Stack launchers allow you to start multiple services with a single command, making it easy to get the entire system running quickly.

## Available Stack Launchers

### 1. Full Stack (All Services)

**Starts:**
- Backend Analysis Server (Port 5001)
- Combined Keyword Search (Port 5000)
- Electron Desktop App

**When to use:**
- You want all features available
- Using both real-time monitoring AND web-based search
- Testing the complete system

**Windows:**
```batch
START_ALL_SERVICES.bat
```

**Linux/Mac:**
```bash
chmod +x start-all-services.sh
./start-all-services.sh
```

### 2. Minimal Stack (Essential Services)

**Starts:**
- Backend Analysis Server (Port 5001)
- Electron Desktop App

**When to use:**
- You only need real-time channel monitoring
- Don't need the web-based keyword search
- Want to minimize resource usage
- **This is the recommended setup for most users**

**Windows:**
```batch
START_MINIMAL_STACK.bat
```

**Linux/Mac:**
```bash
chmod +x start-minimal-stack.sh
./start-minimal-stack.sh
```

### 3. Stop All Services

**Windows:**
```batch
STOP_ALL_SERVICES.bat
```

**Linux/Mac:**
```bash
chmod +x stop-all-services.sh
./stop-all-services.sh
```

Or simply press `Ctrl+C` in the terminal where services are running (Linux/Mac).

## How It Works

### Windows Stack Launchers

1. **Opens separate console windows** for each service
2. Each service runs in its own window with visible logs
3. Close individual windows to stop specific services
4. Or run `STOP_ALL_SERVICES.bat` to stop everything at once

**Startup sequence:**
1. Backend Server starts first (3 second delay)
2. Combined Keyword starts next (2 second delay) - Full stack only
3. Electron App starts last

### Linux/Mac Stack Launchers

1. **Runs all services in the background**
2. Logs are written to files:
   - `backend.log` - Backend server logs
   - `combined-keyword.log` - Web app logs (full stack only)
   - `electron.log` - Electron app logs
3. Press `Ctrl+C` to stop all services
4. Or run `./stop-all-services.sh` from another terminal

**Features:**
- Automatic cleanup on exit
- Process ID tracking
- Port conflict detection
- Virtual environment management

## Comparison

| Feature | Full Stack | Minimal Stack | Individual |
|---------|-----------|---------------|------------|
| Backend Server | ✓ | ✓ | Manual |
| Electron App | ✓ | ✓ | Manual |
| Combined Keyword | ✓ | ✗ | Manual |
| Whisper GUI | ✗ | ✗ | Manual |
| Resource Usage | High | Medium | Manual |
| Startup Time | ~8 seconds | ~5 seconds | Immediate |
| Best For | All features | Monitoring only | Fine control |

## Recommended Workflows

### Workflow 1: Channel Monitoring (Most Common)
**Use:** Minimal Stack
```batch
# Windows
START_MINIMAL_STACK.bat

# Linux/Mac
./start-minimal-stack.sh
```
✓ Backend for analysis
✓ Electron for monitoring
✓ Automatic keyword detection
✗ No web interface (not needed)

### Workflow 2: Complete System
**Use:** Full Stack
```batch
# Windows
START_ALL_SERVICES.bat

# Linux/Mac
./start-all-services.sh
```
✓ Everything running
✓ Web interface available at http://localhost:5000
✓ Electron monitoring
✓ All analysis features

### Workflow 3: One-time Analysis
**Use:** Individual Services
```batch
# Windows
START_COMBINED_KEYWORD.bat

# Linux/Mac
cd "Combined Keyword" && python3 app.py
```
✓ Just the web interface
✓ Minimal resource usage
✗ No real-time monitoring

## Troubleshooting Stack Launchers

### Problem: Services won't start

**Windows:**
1. Check if ports are already in use:
   ```powershell
   netstat -ano | findstr ":5000 :5001"
   ```
2. Run `STOP_ALL_SERVICES.bat` first
3. Then try starting again

**Linux/Mac:**
1. Check if ports are in use:
   ```bash
   lsof -i :5000
   lsof -i :5001
   ```
2. Run `./stop-all-services.sh` first
3. Make scripts executable: `chmod +x *.sh`
4. Check log files for errors

### Problem: Can't stop services

**Windows:**
1. Run `STOP_ALL_SERVICES.bat`
2. If that fails, manually kill processes:
   ```powershell
   taskkill /IM electron.exe /F
   taskkill /IM python.exe /F
   ```

**Linux/Mac:**
1. Press `Ctrl+C` in the terminal
2. Run `./stop-all-services.sh`
3. Force kill if needed:
   ```bash
   pkill -9 electron
   pkill -9 python3
   ```

### Problem: Backend shows offline in Electron

1. Wait 5-10 seconds after startup
2. Backend takes time to load Whisper model
3. Check backend console/log for errors
4. Try accessing: http://localhost:5001/health

### Problem: Electron app doesn't appear

**Windows:**
1. Check if the window is behind other windows
2. Look for "Electron App" in taskbar
3. Check the console window for errors

**Linux/Mac:**
1. Check `electron.log` for errors
2. Make sure X11/Wayland display is available
3. Try running `npm start` manually

## Advanced Usage

### Custom Startup Order

If you need specific timing, start services manually in order:

```bash
# Start backend first
START_BACKEND_SERVER.bat

# Wait 5 seconds
timeout /t 5

# Start Electron
START_ELECTRON_APP.bat
```

### Running on Different Ports

Edit the respective files:
- Backend: `backend.py` line 183
- Combined Keyword: `Combined Keyword/app.py` last line
- Update stack launchers accordingly

### Running Without Stack Launchers

You can always run services individually:

**Backend:**
```bash
python backend.py
```

**Electron:**
```bash
npm start
```

**Combined Keyword:**
```bash
cd "Combined Keyword"
python app.py
```

## Log Files (Linux/Mac)

When using stack launchers on Linux/Mac, logs are written to:

```
Youtube-Live-Monitor-main/
├── backend.log           # Backend server logs
├── combined-keyword.log  # Web app logs (full stack)
└── electron.log          # Electron app logs
```

View logs in real-time:
```bash
tail -f backend.log
tail -f electron.log
tail -f combined-keyword.log
```

## Resource Usage

### Full Stack
- **CPU:** Medium (Whisper model + 3 services)
- **RAM:** ~2-4 GB (depending on Whisper model)
- **Disk:** Minimal (temp files auto-cleaned)

### Minimal Stack
- **CPU:** Low-Medium (Whisper model + 2 services)
- **RAM:** ~2-3 GB
- **Disk:** Minimal

### Tips to Reduce Resource Usage
1. Use "tiny" Whisper model in `backend.py`
2. Close unused applications
3. Use minimal stack instead of full stack
4. Limit concurrent video processing

## Quick Reference

| Task | Windows | Linux/Mac |
|------|---------|-----------|
| Start Full Stack | `START_ALL_SERVICES.bat` | `./start-all-services.sh` |
| Start Minimal Stack | `START_MINIMAL_STACK.bat` | `./start-minimal-stack.sh` |
| Stop All Services | `STOP_ALL_SERVICES.bat` | `./stop-all-services.sh` or `Ctrl+C` |
| View Backend Status | Check console window | `tail -f backend.log` |
| View Electron Status | Check console window | `tail -f electron.log` |
| View Web App Status | Check console window | `tail -f combined-keyword.log` |
| Test Backend | http://localhost:5001/health | http://localhost:5001/health |
| Open Web Interface | http://localhost:5000 | http://localhost:5000 |

## Next Steps

1. Try the minimal stack first: `START_MINIMAL_STACK.bat` or `./start-minimal-stack.sh`
2. Configure your channels in the Electron app
3. Test with a known live channel
4. Check status indicators to confirm everything is connected
5. Review logs if anything isn't working
6. Use `TROUBLESHOOTING.md` for specific issues
