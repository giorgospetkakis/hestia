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

# Ensure API directory exists and is properly set up
echo "🔧 Setting up API directory..."
mkdir -p api
if [ ! -f api/index.py ]; then
    echo "📝 Creating API entry point..."
    cat > api/index.py << 'EOF'
# Serverless function entry point
import sys
import os

# Add backend to Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend'))

# Import the FastAPI app from backend
from app.main import app

# Export the app for serverless platforms
handler = app
EOF
fi

echo "✅ Build completed successfully!" 