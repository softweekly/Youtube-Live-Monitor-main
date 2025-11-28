@echo off
echo ============================================
echo YouTube Live Monitor - System Test Suite
echo ============================================
echo.
echo Running comprehensive tests to verify functionality...
echo.

REM Test 1: Check Prerequisites
echo [TEST 1/10] Checking Prerequisites...
echo.

echo   Checking Node.js...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    node --version
    echo   [PASS] Node.js is installed
) else (
    echo   [FAIL] Node.js not found
    set "FAILED=1"
)
echo.

echo   Checking Python...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    python --version
    echo   [PASS] Python is installed
) else (
    echo   [FAIL] Python not found
    set "FAILED=1"
)
echo.

echo   Checking FFmpeg...
ffmpeg -version >nul 2>&1
if %errorlevel% equ 0 (
    echo   [PASS] FFmpeg is installed
) else (
    echo   [WARNING] FFmpeg not found - needed for video processing
)
echo.

REM Test 2: Check Node Dependencies
echo [TEST 2/10] Checking Node.js Dependencies...
if exist "node_modules" (
    echo   [PASS] node_modules folder exists
) else (
    echo   [FAIL] node_modules not found - run: npm install
    set "FAILED=1"
)
echo.

REM Test 3: Check Python Dependencies
echo [TEST 3/10] Checking Python Dependencies...
python -c "import flask" >nul 2>&1
if %errorlevel% equ 0 (
    echo   [PASS] Flask is installed
) else (
    echo   [FAIL] Flask not installed
    set "FAILED=1"
)

python -c "import whisper" >nul 2>&1
if %errorlevel% equ 0 (
    echo   [PASS] Whisper is installed
) else (
    echo   [FAIL] Whisper not installed
    set "FAILED=1"
)

python -c "import yt_dlp" >nul 2>&1
if %errorlevel% equ 0 (
    echo   [PASS] yt-dlp is installed
) else (
    echo   [FAIL] yt-dlp not installed
    set "FAILED=1"
)
echo.

REM Test 4: Check Required Files
echo [TEST 4/10] Checking Required Files...
set "FILES=main.js index.html backend.py package.json"
for %%f in (%FILES%) do (
    if exist "%%f" (
        echo   [PASS] %%f exists
    ) else (
        echo   [FAIL] %%f missing
        set "FAILED=1"
    )
)
echo.

REM Test 5: Check Syntax - JavaScript
echo [TEST 5/10] Checking JavaScript Syntax...
node -c main.js >nul 2>&1
if %errorlevel% equ 0 (
    echo   [PASS] main.js syntax OK
) else (
    echo   [FAIL] main.js has syntax errors
    set "FAILED=1"
)

node -c renderer.js >nul 2>&1
if %errorlevel% equ 0 (
    echo   [PASS] renderer.js syntax OK
) else (
    echo   [FAIL] renderer.js has syntax errors
    set "FAILED=1"
)

node -c preload.js >nul 2>&1
if %errorlevel% equ 0 (
    echo   [PASS] preload.js syntax OK
) else (
    echo   [FAIL] preload.js has syntax errors
    set "FAILED=1"
)
echo.

REM Test 6: Check Syntax - Python
echo [TEST 6/10] Checking Python Syntax...
python -m py_compile backend.py >nul 2>&1
if %errorlevel% equ 0 (
    echo   [PASS] backend.py syntax OK
) else (
    echo   [FAIL] backend.py has syntax errors
    set "FAILED=1"
)

if exist "Combined Keyword\app.py" (
    python -m py_compile "Combined Keyword\app.py" >nul 2>&1
    if %errorlevel% equ 0 (
        echo   [PASS] Combined Keyword\app.py syntax OK
    ) else (
        echo   [FAIL] Combined Keyword\app.py has syntax errors
        set "FAILED=1"
    )
)
echo.

REM Test 7: Test Backend Server Health Endpoint
echo [TEST 7/10] Testing Backend Server (Quick)...
echo   Starting backend server for 10 seconds...
start /B python backend.py >backend_test.log 2>&1
set BACKEND_PID=%ERRORLEVEL%

timeout /t 5 /nobreak >nul

curl -s http://localhost:5001/health >nul 2>&1
if %errorlevel% equ 0 (
    echo   [PASS] Backend server started and health endpoint responding
) else (
    echo   [FAIL] Backend server not responding on port 5001
    set "FAILED=1"
)

REM Kill backend
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5001') do taskkill /PID %%a /F >nul 2>&1
timeout /t 1 /nobreak >nul
echo.

REM Test 8: Check Port Availability
echo [TEST 8/10] Checking Port Availability...
netstat -ano | findstr :5001 >nul 2>&1
if %errorlevel% equ 0 (
    echo   [WARNING] Port 5001 is in use
) else (
    echo   [PASS] Port 5001 is available
)

netstat -ano | findstr :5000 >nul 2>&1
if %errorlevel% equ 0 (
    echo   [WARNING] Port 5000 is in use
) else (
    echo   [PASS] Port 5000 is available
)
echo.

REM Test 9: Check Startup Scripts
echo [TEST 9/10] Checking Startup Scripts...
set "SCRIPTS=START_ELECTRON_APP.bat START_BACKEND_SERVER.bat START_ALL_SERVICES.bat START_MINIMAL_STACK.bat STOP_ALL_SERVICES.bat"
for %%s in (%SCRIPTS%) do (
    if exist "%%s" (
        echo   [PASS] %%s exists
    ) else (
        echo   [FAIL] %%s missing
        set "FAILED=1"
    )
)
echo.

REM Test 10: Check Documentation
echo [TEST 10/10] Checking Documentation...
set "DOCS=README.md SETUP_GUIDE.md TROUBLESHOOTING.md"
for %%d in (%DOCS%) do (
    if exist "%%d" (
        echo   [PASS] %%d exists
    ) else (
        echo   [FAIL] %%d missing
        set "FAILED=1"
    )
)
echo.

REM Summary
echo ============================================
echo Test Summary
echo ============================================
echo.
if defined FAILED (
    echo STATUS: [FAILED] Some tests did not pass
    echo.
    echo Please review the failures above and:
    echo   1. Run: npm install
    echo   2. Run: pip install flask yt-dlp openai-whisper moviepy
    echo   3. Install FFmpeg if needed
    echo   4. Check TROUBLESHOOTING.md for solutions
    echo.
    exit /b 1
) else (
    echo STATUS: [PASSED] All tests passed!
    echo.
    echo Your system is ready to run:
    echo   - START_MINIMAL_STACK.bat (recommended)
    echo   - START_ALL_SERVICES.bat (full stack)
    echo.
    echo Next steps:
    echo   1. Start services with stack launcher
    echo   2. Configure channels in Electron app
    echo   3. Check status indicators
    echo   4. Test with a known live channel
    echo.
)

REM Cleanup
if exist "backend_test.log" del backend_test.log

pause
