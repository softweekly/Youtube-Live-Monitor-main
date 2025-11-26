@echo off
echo ============================================
echo YouTube Live Monitor Suite - Full Stack
echo ============================================
echo.
echo This will start ALL services in separate windows:
echo   1. Backend Analysis Server (Port 5001)
echo   2. Combined Keyword Search (Port 5000)
echo   3. Electron Desktop App
echo.
echo Close any window to stop that service.
echo Press Ctrl+C in this window to see instructions.
echo.
pause

REM Start Backend Server in new window
start "Backend Server (Port 5001)" cmd /k "%~dp0START_BACKEND_SERVER.bat"

REM Wait 3 seconds for backend to initialize
echo Waiting for backend to start...
timeout /t 3 /nobreak >nul

REM Start Combined Keyword in new window
start "Combined Keyword (Port 5000)" cmd /k "%~dp0START_COMBINED_KEYWORD.bat"

REM Wait 2 seconds
echo Waiting for web server to start...
timeout /t 2 /nobreak >nul

REM Start Electron App
start "Electron App" cmd /k "%~dp0START_ELECTRON_APP.bat"

echo.
echo ============================================
echo All Services Started!
echo ============================================
echo.
echo Running services:
echo   • Backend Server:     http://localhost:5001
echo   • Combined Keyword:   http://localhost:5000
echo   • Electron Desktop:   Desktop Application
echo.
echo What's happening now:
echo   1. Backend server is analyzing videos
echo   2. Web interface is ready at port 5000
echo   3. Electron app is monitoring channels
echo.
echo To stop all services:
echo   • Close each window individually, OR
echo   • Run: STOP_ALL_SERVICES.bat
echo.
echo Keep this window open to see these instructions.
echo.
pause
