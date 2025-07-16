#!/bin/bash

# Start script for Railway deployment
# Runs Nginx (reverse proxy) and FastAPI (API server)

set -e

echo "🚀 Starting Hestia with reverse proxy..."

# Start FastAPI server in background
echo "🐍 Starting FastAPI server..."
cd backend
python3 -m uvicorn app.main:app --host 127.0.0.1 --port 8000 &
FASTAPI_PID=$!
cd ..

# Wait a moment for FastAPI to start
sleep 2

# Start Nginx
echo "🌐 Starting Nginx reverse proxy..."
nginx -c /app/nginx.conf -g "daemon off;" &
NGINX_PID=$!

echo "✅ Both services started!"
echo "📊 FastAPI PID: $FASTAPI_PID"
echo "📊 Nginx PID: $NGINX_PID"

# Function to handle shutdown
cleanup() {
    echo "🛑 Shutting down services..."
    kill $FASTAPI_PID 2>/dev/null || true
    kill $NGINX_PID 2>/dev/null || true
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Wait for either process to exit
wait 