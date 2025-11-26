@echo off
echo ============================================
echo Starting Backend Analysis Server (Port 5001)
echo ============================================
echo.
echo This backend server handles video transcription and keyword analysis.
echo Keep this window open while using the Electron app!
echo.
echo Server will start on: http://localhost:5001
echo.
echo Press Ctrl+C to stop the server.
echo.

cd /d "%~dp0"

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8 or higher
    pause
    exit /b 1
)

REM Install requirements if needed
if not exist "requirements_backend.txt" (
    echo Creating requirements file...
    (
        echo yt-dlp
        echo openai-whisper
        echo flask
        echo moviepy
    ) > requirements_backend.txt
)

echo Checking dependencies...
pip install -q -r requirements_backend.txt

echo.
echo Starting backend server...
python backend.py
