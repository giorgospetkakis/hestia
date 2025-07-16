#!/bin/bash

echo "🚀 Deploying Hestia Frontend to Vercel..."

# Navigate to frontend directory
cd frontend

# Check if vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found. Please install it first:"
    echo "npm install -g vercel"
    exit 1
fi

# Deploy to Vercel
echo "📦 Deploying to Vercel..."
vercel --prod

echo "✅ Frontend deployment complete!"
echo "🔗 Check your Vercel dashboard for the deployment URL" 