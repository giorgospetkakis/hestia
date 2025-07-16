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

# Wait for FastAPI to be ready
echo "⏳ Waiting for FastAPI to be ready..."
for i in {1..30}; do
    if curl -f http://127.0.0.1:8000/health >/dev/null 2>&1; then
        echo "✅ FastAPI is ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ FastAPI failed to start within 30 seconds"
        exit 1
    fi
    sleep 1
done

# Start Nginx
echo "🌐 Starting Nginx reverse proxy..."
nginx -c /app/nginx.conf -g "daemon off;" &
NGINX_PID=$!

# Wait for Nginx to be ready
echo "⏳ Waiting for Nginx to be ready..."
sleep 3

# Test the full health check through Nginx
echo "🔍 Testing health check through Nginx..."
for i in {1..10}; do
    if curl -f http://localhost/health >/dev/null 2>&1; then
        echo "✅ Health check is working!"
        break
    fi
    if [ $i -eq 10 ]; then
        echo "❌ Health check failed after 10 attempts"
        exit 1
    fi
    sleep 1
done

echo "✅ Both services started and healthy!"
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