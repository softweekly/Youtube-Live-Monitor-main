# UI Testing Checklist

Use this checklist to verify all UIs are working correctly.

## Pre-Testing Setup

- [ ] Run `QUICK_SETUP.bat` to verify all prerequisites
- [ ] Install Node.js dependencies: `npm install`
- [ ] Ensure FFmpeg is installed and in PATH
- [ ] Configure YouTube Data API key in `Combined Keyword\app.py` (if testing that component)

## 1. Electron App UI Testing

### Start the Application
- [ ] Run `START_ELECTRON_APP.bat`
- [ ] Application window opens without errors
- [ ] UI loads correctly with all sections visible

### Add Channel Testing
- [ ] Click "Add Channel" button
- [ ] New channel input row appears
- [ ] All fields are present: Display name, Keywords, OBS Action, Remove button
- [ ] Drag handle (☰) is visible

### Channel Configuration
- [ ] Enter a channel display name (e.g., `@NASA`)
- [ ] Enter keywords (e.g., `launch, rocket, mission`)
- [ ] Select OBS action from dropdown (No OBS/Stream/Record)
- [ ] Click "Save Settings"
- [ ] Success message appears: "Settings saved successfully!"
- [ ] Reload app - settings should persist

### Drag and Drop
- [ ] Add multiple channels (3+)
- [ ] Click and drag a channel by the ☰ handle
- [ ] Drop it in a different position
- [ ] Order changes correctly
- [ ] Save settings - order persists after reload

### OBS Settings
- [ ] Enter OBS Host (localhost)
- [ ] Enter OBS Port (4455)
- [ ] Enter OBS Password
- [ ] Click Save
- [ ] OBS Status should show "Not configured" or connection attempt

### System Status Section
- [ ] "System Status" section is visible
- [ ] Shows three status indicators:
  - Backend Server status
  - OBS Connection status
  - Last Analysis status
- [ ] Backend Server shows "Checking..." initially

### Error Handling
- [ ] Try saving with invalid channel name
- [ ] Should show error: "Could not find channel ID..."
- [ ] Try saving with empty fields - should save only valid channels
- [ ] Button should show "Saving..." during save operation

## 2. Backend Server Testing

### Start the Server
- [ ] Run `START_BACKEND_SERVER.bat`
- [ ] Server starts without Python errors
- [ ] Shows: "Starting backend server..."
- [ ] Whisper model loads successfully
- [ ] Server running on port 5001

### Health Check
- [ ] Open browser to: http://localhost:5001/health
- [ ] Should show: `{"status":"healthy","service":"YouTube Analysis Backend"}`

### Status in Electron App
- [ ] With backend running, check Electron app
- [ ] Backend Server status should show: "✓ Connected" (green)
- [ ] Without backend running, should show: "✗ Offline" (red)

### Analysis Endpoint (Manual Test)
Use a tool like Postman or curl:
```bash
curl -X POST http://localhost:5001/analyze -H "Content-Type: application/json" -d "{\"video_url\":\"https://youtube.com/watch?v=dQw4w9WgXcQ\",\"keywords\":[\"test\"]}"
```
- [ ] Request is accepted
- [ ] Video downloads (check console output)
- [ ] Transcription starts
- [ ] Results returned with matches array

### Error Handling
- [ ] Send request with missing video_url - should return 400 error
- [ ] Send request with invalid URL - should return error message
- [ ] Send request with non-YouTube URL - should return validation error

## 3. Combined Keyword Search UI Testing

### Start the Application
- [ ] Run `START_COMBINED_KEYWORD.bat`
- [ ] Server starts on port 5000
- [ ] Console shows: "Running on http://localhost:5000"

### Access Web UI
- [ ] Open browser to: http://localhost:5000
- [ ] Page loads: "YouTube Keyword Analyzer"
- [ ] Two input fields visible:
  - YouTube URL
  - Keywords textarea

### Input Validation
- [ ] Click "Run Analysis" with empty URL
- [ ] Should show: "Error: Please enter a YouTube URL"
- [ ] Enter invalid URL (e.g., "google.com")
- [ ] Should show: "Error: Please enter a valid YouTube URL"
- [ ] Enter valid YouTube URL without keywords
- [ ] Should show warning but proceed

### API Key Check
- [ ] If API key not configured (still "YOUR_API_KEY_HERE")
- [ ] Should show error about configuring API key
- [ ] Configure valid API key in `app.py`
- [ ] Restart server
- [ ] Try analysis again

### Full Analysis Flow
- [ ] Enter valid YouTube channel URL
- [ ] Enter keywords: `test, example, demo`
- [ ] Click "Run Analysis"
- [ ] Status message shows: "Processing... This may take a few minutes."
- [ ] On success: "Analysis completed successfully!"
- [ ] Download link appears
- [ ] Click download link - file downloads

### Error Handling
- [ ] Test with restricted/private video
- [ ] Test with invalid channel ID
- [ ] Should show appropriate error messages
- [ ] Network errors should mention checking if backend is running

## 4. Whisper GUI Testing

### Start the Application
- [ ] Run `START_WHISPER_GUI.bat`
- [ ] Dependencies install (first run may take time)
- [ ] GUI window opens: "YouTube Channel Transcriber"

### UI Elements Present
- [ ] Channel URL input field
- [ ] Keywords input field
- [ ] Settings section with:
  - Max Videos spinner
  - Max Duration spinner
  - Model Quality dropdown
  - Output Directory with Browse button
- [ ] "Start Processing" button
- [ ] Progress/log area at bottom

### Configuration
- [ ] Enter YouTube channel URL (e.g., `https://youtube.com/@NASA`)
- [ ] Enter keywords: `launch, space, mission`
- [ ] Set Max Videos: 5
- [ ] Set Max Duration: 30 minutes
- [ ] Select Model: "base"
- [ ] Click Browse - select output directory
- [ ] All settings save correctly

### Processing
- [ ] Click "Start Processing"
- [ ] Button changes to show processing state
- [ ] Progress messages appear in log area
- [ ] Channel info fetched
- [ ] Videos listed with filtering applied
- [ ] Download progress shown
- [ ] Transcription progress shown
- [ ] Keyword matches displayed

### Output Verification
- [ ] Check output directory
- [ ] Folders created: videos/, transcripts/, search_results/
- [ ] Video files downloaded
- [ ] Transcript files created
- [ ] Summary JSON file present
- [ ] Keyword results saved

### Cancel/Stop
- [ ] Start processing
- [ ] Click cancel/stop button (if present)
- [ ] Process stops gracefully
- [ ] Partial results saved

## 5. Integration Testing

### Electron App + Backend Integration
- [ ] Start backend server first
- [ ] Start Electron app
- [ ] Backend status shows "Connected"
- [ ] Add a channel with keywords
- [ ] Save settings
- [ ] Wait for or trigger a live stream detection (or simulate)
- [ ] Check backend console for analysis request
- [ ] Check Electron console for analysis trigger
- [ ] "Last Analysis" status updates

### End-to-End Live Stream Workflow
- [ ] Configure channel that frequently goes live
- [ ] Set keywords relevant to that channel
- [ ] Set OBS action (if OBS is configured)
- [ ] Wait for live detection (check every 15 seconds)
- [ ] Verify:
  - [ ] Live channel appears in "Live Channels" section
  - [ ] Analysis is triggered automatically
  - [ ] Backend processes the video
  - [ ] Keyword matches logged
  - [ ] OBS action triggered (if configured)

## 6. Error Recovery Testing

### Network Interruption
- [ ] Start Electron app with backend running
- [ ] Stop backend server
- [ ] Backend status should change to "Offline"
- [ ] Restart backend server
- [ ] Status should recover to "Connected"

### Invalid Configuration
- [ ] Enter invalid OBS credentials
- [ ] Try to trigger OBS action
- [ ] Should log error but not crash
- [ ] Correct credentials
- [ ] Should connect successfully

### Resource Limits
- [ ] In Whisper GUI, set very high max videos (50+)
- [ ] Should process but may take long time
- [ ] Check system resources don't exhaust
- [ ] Cancel if needed

## 7. Cross-UI Data Verification

### Settings Persistence
- [ ] Configure channels in Electron app
- [ ] Close and reopen app
- [ ] All settings should persist
- [ ] Channels in same order
- [ ] Keywords preserved
- [ ] OBS settings saved

### Output File Locations
- [ ] Backend server: Check `temp_video_downloads/` is cleaned up
- [ ] Combined Keyword: Check `~/Desktop/YouTube_Keyword_Search/` for results
- [ ] Whisper GUI: Check configured output directory for files

## Testing Summary

Total tests: ~100+
- [ ] All Electron App tests passed
- [ ] All Backend Server tests passed
- [ ] All Combined Keyword tests passed
- [ ] All Whisper GUI tests passed
- [ ] All Integration tests passed
- [ ] All Error Recovery tests passed

## Issues Found

Document any issues:

1. Issue: _______________________
   Component: ___________________
   Severity: ____________________
   Steps to reproduce: __________

2. Issue: _______________________
   Component: ___________________
   Severity: ____________________
   Steps to reproduce: __________

## Notes

- Test on clean Windows 10/11 installation if possible
- Verify with different YouTube channels/videos
- Test with various network conditions
- Check console logs for any warnings or errors
- Monitor system resources during long operations

## Final Verification

- [ ] All startup scripts work correctly
- [ ] SETUP_GUIDE.md is accurate
- [ ] All error messages are user-friendly
- [ ] No console errors during normal operation
- [ ] UI is responsive and doesn't freeze
- [ ] Data persists correctly across sessions
- [ ] All dependencies install successfully
