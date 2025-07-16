#!/bin/bash

echo "🚀 Starting Hestia Backend in development mode..."

# Ensure we're in the backend directory
cd "$(dirname "$0")"

# Get the port from environment variable or default to 8000
PORT=${PORT:-8000}
echo "🔧 Using port: $PORT"

# Check if virtual environment exists and activate it
if [ -d "venv" ]; then
    echo "🐍 Activating virtual environment..."
    source venv/bin/activate
fi

# Start FastAPI server
echo "🐍 Starting FastAPI server..."
python3 -m uvicorn app.main:app --host 0.0.0.0 --port $PORT --reload 