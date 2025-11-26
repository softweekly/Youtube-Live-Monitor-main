@echo off
echo ============================================
echo Stopping All Services...
echo ============================================
echo.

REM Kill Node.js processes (Electron app)
echo Stopping Electron App...
taskkill /IM electron.exe /F >nul 2>&1
taskkill /IM node.exe /F >nul 2>&1

REM Kill Python processes (Backend and Combined Keyword)
echo Stopping Python servers...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5001') do taskkill /PID %%a /F >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5000') do taskkill /PID %%a /F >nul 2>&1

echo.
echo ============================================
echo All Services Stopped!
echo ============================================
echo.
echo You can now restart services with:
echo   START_ALL_SERVICES.bat
echo.
pause
