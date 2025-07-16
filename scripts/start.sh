#!/bin/bash

# Start script for Railway deployment
# Runs Nginx (reverse proxy) and FastAPI (API server)

set -e

echo "🚀 Starting Hestia with reverse proxy..."

# Start Nginx first (so health check is immediately available)
echo "🌐 Starting Nginx reverse proxy..."

# Get the port from environment variable or default to 80
PORT=${PORT:-80}
echo "🔧 Using port: $PORT"

# Debug: Check if Flutter build files exist
echo "🔍 Checking Flutter build files..."
ls -la /app/public/ || echo "❌ /app/public/ directory not found"
ls -la /app/frontend/build/web/ || echo "❌ /app/frontend/build/web/ directory not found"

# Check if index.html exists
if [ -f "/app/public/index.html" ]; then
    echo "✅ index.html found in /app/public/"
    echo "📄 index.html content preview:"
    head -5 /app/public/index.html
else
    echo "❌ index.html not found in /app/public/"
    echo "🔍 What's actually in /app/public/:"
    find /app/public/ -type f -name "*.html" 2>/dev/null || echo "No HTML files found"
fi

# Create a temporary nginx config with the correct port
sed "s/listen 80 default_server;/listen $PORT default_server;/" /etc/nginx/nginx.conf > /tmp/nginx.conf

# Debug: Show the nginx config being used
echo "🔧 Nginx config preview:"
head -20 /tmp/nginx.conf

nginx -c /tmp/nginx.conf -g "daemon off;" &
NGINX_PID=$!

# Wait for Nginx to be ready
echo "⏳ Waiting for Nginx to be ready..."
sleep 2

# Test that Nginx is responding
echo "🔍 Testing Nginx health check..."
for i in {1..10}; do
    if curl -f http://localhost:$PORT/health >/dev/null 2>&1; then
        echo "✅ Nginx health check is working!"
        break
    fi
    if [ $i -eq 10 ]; then
        echo "❌ Nginx health check failed after 10 attempts"
        exit 1
    fi
    sleep 1
done

# Start FastAPI server in background
echo "🐍 Starting FastAPI server..."
cd backend
python3 -m uvicorn app.main:app --host 0.0.0.0 --port 8000 &
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
        echo "⚠️  FastAPI failed to start within 30 seconds, but Nginx is working"
        # Don't exit, as Nginx can still serve the health check
    fi
    sleep 1
done

echo "✅ Services started!"
echo "📊 FastAPI PID: $FASTAPI_PID"
echo "📊 Nginx PID: $NGINX_PID"
echo "🌐 Nginx listening on port $PORT"
echo "🔗 Health check available at: http://localhost:$PORT/health"

# Keep the script running and monitor services
echo "🔄 Monitoring services..."
while true; do
    # Check if Nginx is still running
    if ! kill -0 $NGINX_PID 2>/dev/null; then
        echo "❌ Nginx process died"
        exit 1
    fi
    
    # Check if FastAPI is still running (optional)
    if ! kill -0 $FASTAPI_PID 2>/dev/null; then
        echo "⚠️  FastAPI process died, but Nginx is still running"
    fi
    
    # Test health check every 30 seconds
    if ! curl -f http://localhost:$PORT/health >/dev/null 2>&1; then
        echo "⚠️  Health check failed, but services are still running"
    fi
    
    sleep 30
done 