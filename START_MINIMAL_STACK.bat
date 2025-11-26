@echo off
echo ============================================
echo YouTube Live Monitor - Minimal Stack
echo ============================================
echo.
echo This starts only the ESSENTIAL services:
echo   1. Backend Analysis Server (Port 5001)
echo   2. Electron Desktop App
echo.
echo This is the recommended setup for monitoring channels.
echo Combined Keyword Search is optional - run separately if needed.
echo.
pause

REM Start Backend Server in new window
start "Backend Server (Port 5001)" cmd /k "%~dp0START_BACKEND_SERVER.bat"

REM Wait 3 seconds for backend to initialize
echo Waiting for backend to start...
timeout /t 3 /nobreak >nul

REM Start Electron App
start "Electron App" cmd /k "%~dp0START_ELECTRON_APP.bat"

echo.
echo ============================================
echo Minimal Stack Started!
echo ============================================
echo.
echo Running services:
echo   • Backend Server:     http://localhost:5001
echo   • Electron Desktop:   Desktop Application
echo.
echo The Electron app will monitor your channels and
echo automatically trigger keyword analysis via the backend.
echo.
echo To also use Combined Keyword Search, run:
echo   START_COMBINED_KEYWORD.bat
echo.
echo To stop services, close the windows or run:
echo   STOP_ALL_SERVICES.bat
echo.
pause
