@echo off
echo ============================================
echo Starting Combined Keyword Search App
echo ============================================
echo.
echo This web app lets you search YouTube channel videos for keywords.
echo.
echo Server will start on: http://localhost:5000
echo Open your browser and go to that URL
echo.
echo Press Ctrl+C to stop the server.
echo.

cd /d "%~dp0\Combined Keyword"

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8 or higher
    pause
    exit /b 1
)

REM Install requirements if needed
echo Checking dependencies...
pip install -q flask google-api-python-client youtube-transcript-api

echo.
echo Starting Combined Keyword Search App...
echo.
echo IMPORTANT: Edit app.py and replace YOUR_API_KEY_HERE with your YouTube Data API key!
echo.
python app.py
