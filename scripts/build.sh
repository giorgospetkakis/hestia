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

# For Vercel deployment, use pre-built Flutter web files
if [ "$BUILD_FOR_VERCEL" = true ]; then
    echo "🌐 Using pre-built Flutter web files for Vercel deployment..."
    if [ ! -d "frontend/build/web" ]; then
        echo "❌ Error: frontend/build/web directory not found!"
        echo "💡 Please run 'just build-web' locally and commit the build files."
        exit 1
    fi
    echo "✅ Found pre-built Flutter web files"
else
    # Local development - build Flutter
    echo "📱 Installing Flutter dependencies..."
    cd frontend
    flutter pub get
    
    # Build frontend for web
    echo "🏗️ Building Flutter web app..."
    flutter build web --release
    cd ..
fi

echo "✅ Build completed successfully!" 