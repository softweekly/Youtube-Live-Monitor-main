@echo off
echo ============================================
echo Starting YouTube Live Monitor (Electron App)
echo ============================================
echo.
echo This will open the desktop application for monitoring YouTube live streams.
echo Make sure you have run "npm install" first!
echo.
echo Press Ctrl+C to stop the application.
echo.

cd /d "%~dp0"
npm start
