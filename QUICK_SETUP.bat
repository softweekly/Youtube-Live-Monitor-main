@echo off
echo ============================================
echo YouTube Live Monitor Suite - Quick Setup
echo ============================================
echo.
echo This will help you set up all components.
echo.

REM Check Node.js
echo [1/4] Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed!
    echo Please download and install Node.js from: https://nodejs.org/
    pause
    exit /b 1
) else (
    echo [OK] Node.js is installed
)

REM Check Python
echo [2/4] Checking Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed!
    echo Please download and install Python 3.8+ from: https://python.org/
    pause
    exit /b 1
) else (
    echo [OK] Python is installed
)

REM Check FFmpeg
echo [3/4] Checking FFmpeg...
ffmpeg -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] FFmpeg is not installed or not in PATH!
    echo FFmpeg is required for video processing.
    echo Download from: https://ffmpeg.org/download.html
    echo.
    echo Continue anyway? (Y/N)
    choice /C YN /N
    if errorlevel 2 exit /b 1
) else (
    echo [OK] FFmpeg is installed
)

echo.
echo [4/4] Installing Electron App Dependencies...
cd /d "%~dp0"
if not exist "node_modules" (
    echo Running npm install (this may take a few minutes)...
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install Node.js dependencies
        pause
        exit /b 1
    )
    echo [OK] Node.js dependencies installed
) else (
    echo [OK] Dependencies already installed
)

echo.
echo ============================================
echo Setup Complete!
echo ============================================
echo.
echo You can now run the following applications:
echo.
echo 1. START_ELECTRON_APP.bat       - Main monitoring app
echo 2. START_BACKEND_SERVER.bat     - Analysis backend (required for app)
echo 3. START_COMBINED_KEYWORD.bat   - Web keyword search
echo 4. START_WHISPER_GUI.bat        - Video transcription GUI
echo.
echo IMPORTANT: Configure your YouTube Data API key in:
echo    Combined Keyword\app.py
echo.
echo See SETUP_GUIDE.md for detailed instructions.
echo.
pause
