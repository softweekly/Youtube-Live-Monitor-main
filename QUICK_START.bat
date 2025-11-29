@echo off
echo ============================================
echo YouTube Live Monitor - QUICK START
echo ============================================
echo.
echo Checking setup...
echo.

cd /d "%~dp0"

REM Check if Node.js is installed
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js is not installed!
    echo Please install Node.js from: https://nodejs.org/
    pause
    exit /b 1
)

REM Check if Python is installed
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed!
    echo Please install Python from: https://www.python.org/downloads/
    pause
    exit /b 1
)

REM Create virtual environment if it doesn't exist
if not exist ".venv" (
    echo Creating Python virtual environment...
    python -m venv .venv
    if %errorlevel% neq 0 (
        echo ERROR: Failed to create virtual environment
        pause
        exit /b 1
    )
    echo Virtual environment created!
    echo.
)

REM Install Node dependencies if needed
if not exist "node_modules" (
    echo Installing Node.js dependencies...
    call npm install
    if %errorlevel% neq 0 (
        echo ERROR: Failed to install Node dependencies
        pause
        exit /b 1
    )
    echo Node dependencies installed!
    echo.
)

REM Install Python dependencies
echo Installing Python dependencies...
.venv\Scripts\pip.exe install -q -r requirements.txt
if %errorlevel% neq 0 (
    echo ERROR: Failed to install Python dependencies
    pause
    exit /b 1
)
echo Python dependencies installed!
echo.

REM Start the services
echo ============================================
echo Starting Services...
echo ============================================
echo.

REM Start Backend Server in new window
start "Backend Server (Port 5001)" cmd /k "%~dp0START_BACKEND_SERVER.bat"

REM Wait for backend to load Whisper model
echo Waiting for backend to initialize (20 seconds)...
timeout /t 20 /nobreak >nul

REM Start Electron App
start "Electron App" cmd /k "%~dp0START_ELECTRON_APP.bat"

echo.
echo ============================================
echo YouTube Live Monitor Started! 🎉
echo ============================================
echo.
echo Two windows opened:
echo   1. Backend Server - Keep this running
echo   2. Electron App - Your monitoring dashboard
echo.
echo Backend: http://localhost:5001/health
echo.
echo To stop: Close both windows or run STOP_ALL_SERVICES.bat
echo.
pause
