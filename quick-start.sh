#!/bin/bash

echo "============================================"
echo "YouTube Live Monitor - QUICK START"
echo "============================================"
echo ""
echo "Checking setup..."
echo ""

cd "$(dirname "$0")"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js is not installed!"
    echo "Please install Node.js from: https://nodejs.org/"
    exit 1
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python is not installed!"
    echo "Please install Python from: https://www.python.org/downloads/"
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv .venv
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to create virtual environment"
        exit 1
    fi
    echo "Virtual environment created!"
    echo ""
fi

# Install Node dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing Node.js dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to install Node dependencies"
        exit 1
    fi
    echo "Node dependencies installed!"
    echo ""
fi

# Install Python dependencies
echo "Installing Python dependencies..."
.venv/bin/pip install -q -r requirements.txt
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install Python dependencies"
    exit 1
fi
echo "Python dependencies installed!"
echo ""

# Start the services
echo "============================================"
echo "Starting Services..."
echo "============================================"
echo ""

# Start Backend Server in background
echo "Starting backend server..."
.venv/bin/python backend.py &
BACKEND_PID=$!

# Wait for backend to load Whisper model
echo "Waiting for backend to initialize (20 seconds)..."
sleep 20

# Start Electron App
echo "Starting Electron app..."
npm start &
ELECTRON_PID=$!

echo ""
echo "============================================"
echo "YouTube Live Monitor Started! 🎉"
echo "============================================"
echo ""
echo "Services running:"
echo "  Backend PID: $BACKEND_PID"
echo "  Electron PID: $ELECTRON_PID"
echo ""
echo "Backend: http://localhost:5001/health"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Wait for user interrupt
trap "kill $BACKEND_PID $ELECTRON_PID 2>/dev/null; exit" INT TERM

wait
