#!/bin/bash

# Test script to verify health check functionality

echo "🧪 Testing Hestia health check..."

# Test FastAPI directly
echo "1. Testing FastAPI health endpoint..."
if curl -f http://127.0.0.1:8000/health >/dev/null 2>&1; then
    echo "✅ FastAPI health check passed"
else
    echo "❌ FastAPI health check failed"
    exit 1
fi

# Test through Nginx
echo "2. Testing Nginx health endpoint..."
if curl -f http://localhost/health >/dev/null 2>&1; then
    echo "✅ Nginx health check passed"
else
    echo "❌ Nginx health check failed"
    exit 1
fi

# Test API endpoint
echo "3. Testing API endpoint..."
if curl -f http://localhost/api/meals >/dev/null 2>&1; then
    echo "✅ API endpoint test passed"
else
    echo "❌ API endpoint test failed"
    exit 1
fi

echo "🎉 All health checks passed!" 