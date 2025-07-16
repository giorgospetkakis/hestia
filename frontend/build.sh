#!/bin/bash

set -e

echo "🚀 Setting up Flutter environment..."

# Install Flutter if not already available
if ! command -v flutter &> /dev/null; then
    echo "📦 Installing Flutter..."
    
    # Set Flutter home directory
    FLUTTER_HOME="${HOME}/flutter"
    
    # Download Flutter
    git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME
    export PATH="$FLUTTER_HOME/bin:$PATH"
    
    # Configure Flutter
    flutter doctor --android-licenses || true
    flutter config --enable-web
else
    echo "✅ Flutter already available"
fi

echo "📦 Installing dependencies..."
flutter pub get

echo "🔨 Building Flutter web app..."
flutter build web --release --base-href /

echo "✅ Build complete!"
ls -la build/web/ 