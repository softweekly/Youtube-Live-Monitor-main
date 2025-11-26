@echo off
echo ============================================
echo Starting Whisper Video Transcriber GUI
echo ============================================
echo.
echo This GUI lets you download and transcribe YouTube channel videos.
echo.
echo Press Ctrl+C to close the application.
echo.

cd /d "%~dp0\Whisper downloads"

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8 or higher
    pause
    exit /b 1
)

REM Check if requirements file exists
if not exist "requirements.txt" (
    echo ERROR: requirements.txt not found
    pause
    exit /b 1
)

echo Checking dependencies (this may take a while on first run)...
pip install -q -r requirements.txt

echo.
echo Starting Whisper GUI...
python youtube_gui.py
