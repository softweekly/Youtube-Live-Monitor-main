# Quick Test Guide - YouTube Live Monitor

## Test Your Setup (5 Minutes)

### Test 1: Backend Health Check ✅

```bash
# Start backend
python backend.py

# Wait 20 seconds for Whisper model to load

# In browser or new terminal:
curl http://localhost:5001/health

# Expected response:
# {"status":"healthy","service":"YouTube Analysis Backend"}
```

**✅ Pass:** Backend responds with healthy status  
**❌ Fail:** Check Python dependencies: `pip install -r requirements.txt`

---

### Test 2: Launch Electron App ✅

```bash
npm start
```

**✅ Pass:** App window opens with YouTube Live Monitor UI  
**❌ Fail:** Check Node dependencies: `npm install`

---

### Test 3: Add Test Channel ✅

1. In the app, click "Add Channel"
2. Enter: `@NASA` (or any channel you like)
3. Keywords: `space, launch, rocket`
4. OBS Action: `No OBS`
5. Click "Save Settings"

**✅ Pass:** Channel appears in list  
**❌ Fail:** Check browser console (F12) for errors

---

### Test 4: Check Status Indicators ✅

Look at "System Status" section:

- **Backend Server:** Should show "Online" (green)
- **OBS Connection:** "Not configured" (expected if no OBS)
- **Recording Status:** "Idle"

**✅ Pass:** Backend shows Online  
**❌ Fail:** Restart backend.py and wait 20 seconds

---

### Test 5: Cookies Setup (Optional) ✅

**For Member-Only Streams:**

1. Install browser extension: "Get cookies.txt LOCALLY"
2. Go to youtube.com (make sure you're logged in)
3. Export cookies using the extension
4. Copy the cookie text
5. Paste into "YouTube Cookies" field in app
6. Save settings

**✅ Pass:** Cookies saved (no error message)  
**❌ Fail:** Make sure cookies are in Netscape format

---

### Test 6: Download Test (Live Stream) ✅

**Option A: Wait for Real Stream**
1. Add a channel that streams regularly
2. Leave app running
3. When channel goes live:
   - Check `live_stream_recordings/` folder
   - Should see video file downloading

**Option B: Manual Test with Past Live Stream**

Open terminal and test backend directly:

```bash
curl -X POST http://localhost:5001/download \
  -H "Content-Type: application/json" \
  -d '{
    "video_url": "https://www.youtube.com/watch?v=jfKfPfyJRdk",
    "channel_name": "Test Channel"
  }'
```

**Windows PowerShell version:**
```powershell
Invoke-WebRequest -Uri http://localhost:5001/download `
  -Method POST `
  -ContentType "application/json" `
  -Body '{"video_url":"https://www.youtube.com/watch?v=jfKfPfyJRdk","channel_name":"Test Channel"}'
```

**✅ Pass:** Video downloads to `live_stream_recordings/`  
**❌ Fail:** Check yt-dlp is installed: `pip install yt-dlp`

---

### Test 7: Keyword Analysis Test ✅

```bash
curl -X POST http://localhost:5001/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "video_url": "https://www.youtube.com/watch?v=jfKfPfyJRdk",
    "keywords": ["lofi", "music", "chill"]
  }'
```

**Windows PowerShell:**
```powershell
Invoke-WebRequest -Uri http://localhost:5001/analyze `
  -Method POST `
  -ContentType "application/json" `
  -Body '{"video_url":"https://www.youtube.com/watch?v=jfKfPfyJRdk","keywords":["lofi","music","chill"]}'
```

**✅ Pass:** Returns JSON with matches array  
**❌ Fail:** Check Whisper is installed: `pip install openai-whisper`

---

## Full Stack Test (Use Stack Launcher) ✅

### Windows:
```bash
START_MINIMAL_STACK.bat
```

### Linux/Mac:
```bash
./start-minimal-stack.sh
```

This starts:
1. Backend server (port 5001)
2. Electron app

**✅ Pass:** Both windows open, no errors  
**❌ Fail:** Check individual tests above

---

## Real World Test Scenario

### Setup (2 minutes):
1. Launch: `START_MINIMAL_STACK.bat`
2. Add channel: `@24/7 Live Channel` or similar
3. Keywords: `news, breaking, live`
4. Save

### Monitor (Wait for live):
- App checks every 15 seconds
- When stream detected:
  - Status shows "Recording [Channel]..."
  - Download starts in `live_stream_recordings/`
  - Keywords analyzed automatically

### Verify:
1. Check `live_stream_recordings/` folder
2. Video file should appear
3. Backend logs show keyword matches (if found)

---

## Troubleshooting Quick Fixes

### Backend Won't Start
```bash
pip install -r requirements.txt
python backend.py
# Wait 20 seconds for Whisper model
```

### Electron Won't Start
```bash
npm install
npm start
```

### Downloads Fail
- Check FFmpeg is installed: `ffmpeg -version`
- Check yt-dlp is working: `yt-dlp --version`
- Try simpler video URL first

### Member-Only Streams Fail
- Re-export cookies (they expire)
- Make sure you're logged into YouTube
- Check cookies are Netscape format

---

## Success Criteria ✅

You're ready when:
- ✅ Backend responds to /health
- ✅ Electron app opens
- ✅ Can add channels
- ✅ Backend status shows "Online"
- ✅ Test download works
- ✅ Cookies saved (if using member-only)

**Time to start monitoring channels!** 🎉
