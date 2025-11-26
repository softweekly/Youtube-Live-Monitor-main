#!/bin/bash

# YouTube Live Monitor Suite - Stop All Services (Linux/Mac)

echo "============================================"
echo "Stopping All Services..."
echo "============================================"
echo ""

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Kill processes by port
echo "Stopping Backend Server (Port 5001)..."
lsof -ti:5001 | xargs -r kill -9 2>/dev/null && echo "  ✓ Backend stopped" || echo "  • Backend not running"

echo "Stopping Combined Keyword (Port 5000)..."
lsof -ti:5000 | xargs -r kill -9 2>/dev/null && echo "  ✓ Combined Keyword stopped" || echo "  • Combined Keyword not running"

echo "Stopping Electron App..."
pkill -f electron 2>/dev/null && echo "  ✓ Electron stopped" || echo "  • Electron not running"
pkill -f "npm start" 2>/dev/null

# Also kill by process name
pkill -f "backend.py" 2>/dev/null
pkill -f "app.py" 2>/dev/null

echo ""
echo "============================================"
echo "All Services Stopped!"
echo "============================================"
echo ""
echo "You can restart services with:"
echo "  ./start-all-services.sh"
echo ""
