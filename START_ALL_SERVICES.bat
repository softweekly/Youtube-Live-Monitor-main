@echo off
echo ============================================
echo YouTube Live Monitor - Full Stack
echo ============================================
echo.
echo This will start BOTH services in separate windows:
echo   1. Backend Analysis Server (Port 5001)
echo   2. Electron Desktop App
echo.
echo Close any window to stop that service.
echo Press Ctrl+C in this window to see instructions.
echo.
pause

REM Start Backend Server in new window
start "Backend Server (Port 5001)" cmd /k "%~dp0START_BACKEND_SERVER.bat"

REM Wait 5 seconds for backend to initialize (Whisper model load time)
echo Waiting for backend to start...
timeout /t 5 /nobreak >nul

REM Start Electron App
start "Electron App" cmd /k "%~dp0START_ELECTRON_APP.bat"

echo.
echo ============================================
echo All Services Started!
echo ============================================
echo.
echo Running services:
echo   • Backend Server:     http://localhost:5001/health
echo   • Electron Desktop:   Desktop Application
echo.
echo What's happening now:
echo   1. Backend server is ready for video analysis
echo   2. Electron app is monitoring YouTube channels
echo.
echo To stop all services:
echo   • Close each window individually, OR
echo   • Run: STOP_ALL_SERVICES.bat
echo.
echo Keep this window open to see these instructions.
echo.
pause
