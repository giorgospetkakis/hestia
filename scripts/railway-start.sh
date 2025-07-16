#!/bin/bash

# Railway start script for Hestia
# Builds Flutter web app and starts FastAPI server

set -e

echo "🚀 Starting Hestia on Railway..."

# Install Flutter if not available
if ! command -v flutter &> /dev/null; then
    echo "📱 Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
    export PATH="$PWD/flutter/bin:$PATH"
    flutter doctor
fi

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
cd backend
python3 -m pip install --upgrade pip
pip3 install -r requirements.txt
cd ..

# Install Flutter dependencies and build
echo "📱 Installing Flutter dependencies..."
cd frontend
flutter pub get

# Build frontend for web
echo "🏗️ Building Flutter web app..."
flutter build web --release
cd ..

# Copy built files to backend static directory
echo "📋 Copying Flutter build to backend static directory..."
mkdir -p backend/static
cp -r frontend/build/web/* backend/static/

# Start FastAPI server
echo "🚀 Starting FastAPI server..."
cd backend
python3 -m uvicorn app.main:app --host 0.0.0.0 --port $PORT 