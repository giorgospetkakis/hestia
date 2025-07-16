from fastapi import APIRouter
import time
import psutil
import os

router = APIRouter(tags=["health"])

@router.get("/health")
async def health_check():
    """Health check endpoint for Railway deployment"""
    return {
        "status": "healthy",
        "service": "hestia-api",
        "timestamp": time.time(),
        "version": "0.1.0",
        "uptime": time.time() - psutil.boot_time() if hasattr(psutil, 'boot_time') else 0,
        "memory_usage": psutil.virtual_memory().percent if hasattr(psutil, 'virtual_memory') else 0,
        "cpu_usage": psutil.cpu_percent(interval=1) if hasattr(psutil, 'cpu_percent') else 0,
    }

@router.get("/health/simple")
async def simple_health_check():
    """Simple health check endpoint"""
    return {"status": "ok"} 