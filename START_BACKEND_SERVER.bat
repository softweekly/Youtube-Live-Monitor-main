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

REM Check if virtual environment exists
if exist ".venv\Scripts\python.exe" (
    echo Using virtual environment (.venv)
    set PYTHON_CMD=.venv\Scripts\python.exe
    set PIP_CMD=.venv\Scripts\pip.exe
) else (
    echo Using system Python
    set PYTHON_CMD=python
    set PIP_CMD=pip
)

REM Check if Python is available
%PYTHON_CMD% --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8 or higher
    pause
    exit /b 1
)

echo Checking dependencies...
%PIP_CMD% install -q -r requirements.txt

echo.
echo Starting backend server...
%PYTHON_CMD% backend.py
