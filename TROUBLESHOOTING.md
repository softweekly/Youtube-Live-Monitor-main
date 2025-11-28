pip install -r requirements.txt# Quick Troubleshooting Guide

## 🔴 Problem: Backend Server shows "Offline"

**Symptoms:** Red status indicator in Electron app

**Solutions:**
1. Make sure `START_BACKEND_SERVER.bat` is running
2. Check if port 5001 is already in use:
   ```powershell
   netstat -ano | findstr :5001
   ```
3. Look for Python errors in backend console window
4. Verify Python and dependencies are installed:
   ```powershell
   python --version
   pip list | findstr flask
   ```

## 🔴 Problem: "Could not find channel ID for @channelname"

**Symptoms:** Error when saving channel in Electron app

**Solutions:**
1. Try the full URL instead: `https://youtube.com/@channelname`
2. Check spelling - channel names are case-sensitive
3. Try the channel ID directly (starts with "UC"):
   - Go to channel page
   - View page source
   - Search for "channelId"
   - Copy the UC... ID
4. For older channels without @ handles, use: `youtube.com/c/ChannelName`

## 🔴 Problem: OBS won't connect

**Symptoms:** "OBS Connection: ✗ Offline"

**Solutions:**
1. Install OBS WebSocket plugin:
   - Download from: https://github.com/obsproject/obs-websocket/releases
   - Version 5.x required
2. Enable in OBS:
   - Tools → WebSocket Server Settings
   - Check "Enable WebSocket server"
   - Note the port (usually 4455)
   - Set a password
3. Enter exact settings in Electron app:
   - Host: `localhost`
   - Port: `4455` (or your port)
   - Password: (your password)
4. Make sure OBS is running BEFORE starting Electron app

## 🔴 Problem: Videos won't download

**Symptoms:** "Failed to download video" error

**Solutions:**
1. Check if FFmpeg is installed:
   ```powershell
   ffmpeg -version
   ```
   If not installed:
   - Download from: https://ffmpeg.org/download.html
   - Extract to C:\ffmpeg
   - Add C:\ffmpeg\bin to PATH
   - Restart terminal

2. Check internet connection
3. Verify YouTube URL is correct
4. Try a different video (some may be restricted)
5. Add YouTube cookies for age-restricted/private videos

## 🔴 Problem: Transcription is very slow

**Symptoms:** Takes hours to transcribe

**Solutions:**
1. Use smaller Whisper model:
   - Edit `backend.py` line 137
   - Change `"tiny"` instead of `"large"`
   - Restart backend server

2. Filter videos by duration:
   - In Whisper GUI: Set "Max Duration: 30 minutes"
   - Shorter videos = faster processing

3. Reduce video count:
   - Set "Max Videos: 5" instead of 50

4. Check CPU usage - close other applications

5. For GPU acceleration (much faster):
   - Install CUDA toolkit
   - Install PyTorch with CUDA support

## 🔴 Problem: "Invalid API key" in Combined Keyword

**Symptoms:** Error when running analysis

**Solutions:**
1. Get API key:
   - Go to: https://console.cloud.google.com/
   - Create new project
   - Enable "YouTube Data API v3"
   - Create credentials → API Key
   - Copy the key

2. Configure in code:
   - Open `Combined Keyword\app.py`
   - Line 11: Replace `YOUR_API_KEY_HERE` with your key
   - Save file
   - Restart: `START_COMBINED_KEYWORD.bat`

3. Check quota:
   - API has daily limits (10,000 units/day free)
   - Each request uses ~1-3 units
   - If exceeded, wait 24 hours

## 🔴 Problem: Electron app won't start

**Symptoms:** Error when running `START_ELECTRON_APP.bat`

**Solutions:**
1. Check Node.js is installed:
   ```powershell
   node --version
   ```
   Should show v16 or higher

2. Install dependencies:
   ```powershell
   cd "Youtube-Live-Monitor-main"
   npm install
   ```

3. Check for errors in console output

4. Try deleting `node_modules` and reinstalling:
   ```powershell
   rmdir /s node_modules
   npm install
   ```

## 🔴 Problem: Python errors on startup

**Symptoms:** Import errors, module not found

**Solutions:**
1. Check Python version:
   ```powershell
   python --version
   ```
   Need 3.8 or higher

2. Install required packages:
   ```powershell
   # For backend
   pip install flask yt-dlp openai-whisper moviepy
   
   # For Combined Keyword
   pip install flask google-api-python-client youtube-transcript-api
   
   # For Whisper GUI
   cd "Whisper downloads"
   pip install -r requirements.txt
   ```

3. Use virtual environment (recommended):
   ```powershell
   python -m venv venv
   venv\Scripts\activate
   pip install -r requirements.txt
   ```

## 🔴 Problem: Analysis not triggering

**Symptoms:** Live stream detected but no keyword analysis

**Solutions:**
1. Make sure backend server is running
2. Check keywords are entered for that channel
3. Enable verbose logging:
   - In Electron app: Check "Verbose Logging"
   - Save settings
   - Check console for analysis trigger messages

4. Check backend console for incoming requests

5. Manually test backend:
   ```powershell
   curl -X POST http://localhost:5001/health
   ```

## 🔴 Problem: Port already in use

**Symptoms:** "Address already in use" error

**Solutions:**
1. Find what's using the port:
   ```powershell
   # For port 5000
   netstat -ano | findstr :5000
   
   # For port 5001
   netstat -ano | findstr :5001
   ```

2. Kill the process:
   ```powershell
   # Replace PID with the number from netstat
   taskkill /PID <PID> /F
   ```

3. Or change the port:
   - Backend: Edit `backend.py` line 183
   - Combined Keyword: Edit `app.py` last line

## 🔴 Problem: Disk space issues

**Symptoms:** Downloads fail or system slow

**Solutions:**
1. Check available space:
   ```powershell
   wmic logicaldisk get size,freespace,caption
   ```

2. Clean up temp files:
   - Backend: `temp_video_downloads/`
   - Whisper: `youtube_downloads/videos/`

3. Set duration limit in Whisper GUI to avoid large files

4. Backend auto-cleans after each analysis

## 🔴 Problem: Keywords not found but should be

**Symptoms:** Zero matches when keywords should exist

**Solutions:**
1. Check keyword spelling
2. Keywords are case-insensitive, so "Launch" matches "launch"
3. Try broader keywords:
   - Instead of "rocket launch", try "rocket" and "launch" separately
4. Check if video has captions/transcript:
   - Not all videos have transcripts
   - Live streams may need time to generate captions

5. Use verbose logging to see actual transcript text

## 🔴 Problem: Settings don't save

**Symptoms:** Channels disappear after restart

**Solutions:**
1. Make sure to click "Save Settings" button
2. Wait for success message before closing
3. Check if electron-store has permissions:
   - Default location: `%APPDATA%\youtube-live-monitor-main\`
   - Make sure directory is writable

4. Try running as administrator

## 🟡 Warning: High CPU usage

**Solutions:**
1. Using large Whisper model = high CPU (normal)
2. Close unnecessary applications
3. Use "tiny" or "base" model for lower usage
4. Limit concurrent video processing
5. Consider GPU acceleration for intensive work

## 🟡 Warning: High memory usage

**Solutions:**
1. Whisper models use RAM:
   - tiny: ~1 GB
   - base: ~1 GB
   - small: ~2 GB
   - medium: ~5 GB
   - large: ~10 GB

2. Process fewer videos at once
3. Close other applications
4. Use smaller model size

## 📋 Quick Diagnostic Commands

**Check all prerequisites:**
```powershell
# Windows
QUICK_SETUP.bat

# Linux/Mac
./quick-setup.sh  # If created, or check manually
```

**Start all services at once:**
```powershell
# Windows - Full stack
START_ALL_SERVICES.bat

# Windows - Minimal (Backend + Electron only)
START_MINIMAL_STACK.bat

# Linux/Mac - Full stack
./start-all-services.sh

# Linux/Mac - Minimal stack
./start-minimal-stack.sh
```

**Stop all services:**
```powershell
# Windows
STOP_ALL_SERVICES.bat

# Linux/Mac
./stop-all-services.sh
# OR press Ctrl+C in the terminal
```

**Test backend health:**
```powershell
curl http://localhost:5001/health
```

Check if ports are available:
```powershell
netstat -ano | findstr ":5000 :5001 :4455"
```

Check Python packages:
```powershell
pip list
```

Check Node.js packages:
```powershell
npm list
```

View logs in real-time:
- Electron: Check console in app window (Ctrl+Shift+I)
- Backend: Check terminal window where it's running
- Combined Keyword: Check terminal window
- Whisper: Check GUI log area

## 🆘 Still Having Issues?

1. ✅ Run `QUICK_SETUP.bat` first
2. ✅ Check `SETUP_GUIDE.md` for detailed instructions
3. ✅ Enable verbose logging to see detailed errors
4. ✅ Check all terminal windows for error messages
5. ✅ Try components individually to isolate problem
6. ✅ Restart all services
7. ✅ Reboot computer (clears ports and processes)

## 📝 Common Error Messages Explained

| Error Message | Meaning | Solution |
|--------------|---------|----------|
| "Module not found" | Python package missing | `pip install <package>` |
| "EADDRINUSE" | Port already in use | Kill process or change port |
| "Invalid JSON" | Malformed request | Check request format |
| "Failed to download" | Video inaccessible | Check URL, internet, FFmpeg |
| "Could not find channel" | Invalid channel identifier | Use full URL or channel ID |
| "API key invalid" | Wrong or missing API key | Configure key in app.py |
| "Quota exceeded" | YouTube API limit reached | Wait 24 hours |
| "Connection refused" | Service not running | Start the required service |
| "CORS error" | Cross-origin blocked | Check if backend is running |
| "Timeout" | Request took too long | Check internet, reduce video size |

## 💡 Prevention Tips

- ✅ Always start backend server before Electron app
- ✅ Save settings before closing Electron app
- ✅ Keep FFmpeg updated
- ✅ Monitor disk space for video downloads
- ✅ Use verbose logging during setup/testing
- ✅ Start with "tiny" model, upgrade if needed
- ✅ Test with short videos first
- ✅ Keep services running in separate terminal windows
- ✅ Note API quotas before heavy usage
- ✅ Regularly clean temp directories
