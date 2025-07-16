#!/bin/bash

echo "🚀 Deploying Hestia Backend to Railway..."

# Navigate to backend directory
cd backend

# Check if railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Please install it first:"
    echo "npm install -g @railway/cli"
    exit 1
fi

# Deploy to Railway
echo "📦 Deploying to Railway..."
railway up

echo "✅ Backend deployment complete!"
echo "🔗 Check your Railway dashboard for the deployment URL"
echo "📝 Don't forget to update the frontend config with the new backend URL" 