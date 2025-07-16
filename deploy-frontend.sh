#!/bin/bash

echo "🚀 Deploying Hestia Frontend..."

# Navigate to frontend directory
cd frontend

echo "📋 Choose your deployment platform:"
echo "1. Vercel (recommended for Flutter web)"
echo "2. Netlify (alternative)"
echo "3. Build locally and deploy manually"

read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        echo "📦 Deploying to Vercel..."
        if ! command -v vercel &> /dev/null; then
            echo "❌ Vercel CLI not found. Please install it first:"
            echo "npm install -g vercel"
            exit 1
        fi
        vercel --prod
        ;;
    2)
        echo "📦 Deploying to Netlify..."
        if ! command -v netlify &> /dev/null; then
            echo "❌ Netlify CLI not found. Please install it first:"
            echo "npm install -g netlify-cli"
            exit 1
        fi
        netlify deploy --prod
        ;;
    3)
        echo "🔨 Building locally..."
        bash build.sh
        echo "✅ Build complete! Upload the contents of build/web/ to your hosting provider."
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo "✅ Frontend deployment complete!" 