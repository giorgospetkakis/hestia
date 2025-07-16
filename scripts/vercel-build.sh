#!/bin/bash

# Vercel build script for Hestia
# This script is called by Vercel during the build process

set -e

echo "🚀 Starting Vercel build for Hestia..."

# Install Just if not available
if ! command -v just &> /dev/null; then
    echo "📦 Installing Just..."
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
cd backend
python -m pip install --upgrade pip
pip install -r requirements-vercel.txt

# Install Flutter dependencies
echo "📱 Installing Flutter dependencies..."
cd ../frontend
flutter pub get

# Build frontend for web
echo "🏗️ Building Flutter web app..."
flutter build web --release

# Copy built frontend to Vercel output
echo "📁 Copying built files..."
cp -r build/web/* ../frontend/build/web/

echo "✅ Vercel build completed successfully!" 