#!/bin/bash

echo "🚀 Starting Hestia Backend..."

# Get the port from environment variable or default to 8000
PORT=${PORT:-8000}
echo "🔧 Using port: $PORT"

# Start FastAPI server
echo "🐍 Starting FastAPI server..."
python3 -m uvicorn app.main:app --host 0.0.0.0 --port $PORT 