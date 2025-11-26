#!/bin/bash

# YouTube Live Monitor Suite - Full Stack Launcher (Linux/Mac)

echo "============================================"
echo "YouTube Live Monitor Suite - Full Stack"
echo "============================================"
echo ""
echo "This will start ALL services in the background:"
echo "  1. Backend Analysis Server (Port 5001)"
echo "  2. Combined Keyword Search (Port 5000)"
echo "  3. Electron Desktop App"
echo ""
echo "Press Ctrl+C to stop all services."
echo ""

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "============================================"
    echo "Stopping All Services..."
    echo "============================================"
    
    # Kill all background jobs
    jobs -p | xargs -r kill 2>/dev/null
    
    # Kill processes on specific ports
    lsof -ti:5001 | xargs -r kill -9 2>/dev/null
    lsof -ti:5000 | xargs -r kill -9 2>/dev/null
    
    echo "All services stopped!"
    exit 0
}

# Trap Ctrl+C
trap cleanup INT TERM

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed"
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js is not installed"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "ERROR: npm is not installed"
    exit 1
fi

echo "✓ Prerequisites check passed"
echo ""

# Install Node.js dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing Node.js dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to install Node.js dependencies"
        exit 1
    fi
fi

# Create Python virtual environment if needed
if [ ! -d ".venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv .venv
fi

# Activate virtual environment
source .venv/bin/activate

# Install Python dependencies
echo "Installing Python dependencies..."
pip install -q flask yt-dlp openai-whisper moviepy google-api-python-client youtube-transcript-api 2>/dev/null

echo ""
echo "============================================"
echo "Starting Services..."
echo "============================================"
echo ""

# Start Backend Server
echo "Starting Backend Server (Port 5001)..."
python3 backend.py > backend.log 2>&1 &
BACKEND_PID=$!
echo "  • Backend PID: $BACKEND_PID"

# Wait for backend to start
sleep 3

# Check if backend is running
if ! ps -p $BACKEND_PID > /dev/null; then
    echo "ERROR: Backend server failed to start"
    echo "Check backend.log for details"
    exit 1
fi

# Start Combined Keyword Search
echo "Starting Combined Keyword Search (Port 5000)..."
cd "Combined Keyword"
python3 app.py > ../combined-keyword.log 2>&1 &
KEYWORD_PID=$!
cd ..
echo "  • Combined Keyword PID: $KEYWORD_PID"

# Wait for web server to start
sleep 2

# Start Electron App
echo "Starting Electron Desktop App..."
npm start > electron.log 2>&1 &
ELECTRON_PID=$!
echo "  • Electron PID: $ELECTRON_PID"

echo ""
echo "============================================"
echo "All Services Started!"
echo "============================================"
echo ""
echo "Running services:"
echo "  • Backend Server:     http://localhost:5001"
echo "  • Combined Keyword:   http://localhost:5000"
echo "  • Electron Desktop:   Desktop Application"
echo ""
echo "Process IDs:"
echo "  • Backend:            $BACKEND_PID"
echo "  • Combined Keyword:   $KEYWORD_PID"
echo "  • Electron:           $ELECTRON_PID"
echo ""
echo "Log files:"
echo "  • Backend:            backend.log"
echo "  • Combined Keyword:   combined-keyword.log"
echo "  • Electron:           electron.log"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Wait for all background jobs
wait
