#!/bin/bash

# Universal build script for Hestia
# Works locally and on any deployment platform

set -e

echo "🚀 Starting build for Hestia..."

# Check if we're in a Vercel environment
if [ -n "$VERCEL" ] || [ -n "$VERCEL_ENV" ]; then
    echo "🌐 Detected Vercel environment - building for serverless deployment"
    BUILD_FOR_VERCEL=true
else
    echo "🏠 Local environment detected"
    BUILD_FOR_VERCEL=false
fi

# Install Just if not available
if ! command -v just &> /dev/null; then
    echo "📦 Installing Just..."
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
cd backend
python3 -m pip install --upgrade pip
pip3 install -r requirements.txt
cd ..

# Install Flutter if not available
if ! command -v flutter &> /dev/null; then
    echo "📱 Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
    export PATH="$PWD/flutter/bin:$PATH"
    flutter doctor
fi

# Install Flutter dependencies
echo "📱 Installing Flutter dependencies..."
cd frontend
flutter pub get

# Build frontend for web
echo "🏗️ Building Flutter web app..."
flutter build web --release
cd ..

echo "✅ Build completed successfully!" 