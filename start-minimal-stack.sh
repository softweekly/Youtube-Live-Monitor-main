#!/bin/bash

# YouTube Live Monitor - Minimal Stack Launcher (Linux/Mac)

echo "============================================"
echo "YouTube Live Monitor - Minimal Stack"
echo "============================================"
echo ""
echo "This starts only the ESSENTIAL services:"
echo "  1. Backend Analysis Server (Port 5001)"
echo "  2. Electron Desktop App"
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
    echo "Stopping Services..."
    echo "============================================"
    
    # Kill all background jobs
    jobs -p | xargs -r kill 2>/dev/null
    
    # Kill backend process
    lsof -ti:5001 | xargs -r kill -9 2>/dev/null
    
    # Kill electron
    pkill -f electron 2>/dev/null
    
    echo "Services stopped!"
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

echo "✓ Prerequisites check passed"
echo ""

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing Node.js dependencies..."
    npm install
fi

if [ ! -d ".venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv .venv
fi

source .venv/bin/activate
pip install -q flask yt-dlp openai-whisper moviepy 2>/dev/null

echo ""
echo "Starting services..."
echo ""

# Start Backend Server
echo "Starting Backend Server (Port 5001)..."
python3 backend.py > backend.log 2>&1 &
BACKEND_PID=$!
echo "  • Backend PID: $BACKEND_PID"

sleep 3

# Start Electron App
echo "Starting Electron Desktop App..."
npm start > electron.log 2>&1 &
ELECTRON_PID=$!
echo "  • Electron PID: $ELECTRON_PID"

echo ""
echo "============================================"
echo "Minimal Stack Started!"
echo "============================================"
echo ""
echo "Running services:"
echo "  • Backend Server:     http://localhost:5001"
echo "  • Electron Desktop:   Desktop Application"
echo ""
echo "Process IDs:"
echo "  • Backend:            $BACKEND_PID"
echo "  • Electron:           $ELECTRON_PID"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Wait for all background jobs
wait
