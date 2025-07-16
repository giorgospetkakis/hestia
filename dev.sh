#!/bin/bash

echo "🚀 Starting Hestia for local development..."

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose not found. Please install Docker and docker-compose first."
    exit 1
fi

# Build and start services
echo "🔨 Building and starting services..."
docker-compose up --build

echo "✅ Services started!"
echo "🌐 Frontend: http://localhost:3000"
echo "🔗 Backend: http://localhost:8000"
echo "📊 Health check: http://localhost:8000/health" 