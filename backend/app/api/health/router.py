import time
from typing import Dict

import psutil
from fastapi import APIRouter

router = APIRouter(tags=["health"])


@router.get("/health")
async def health_check() -> Dict[str, object]:
    """Health check endpoint for Railway deployment"""
    uptime = time.time() - psutil.boot_time() if hasattr(psutil, "boot_time") else 0
    memory_usage = (
        psutil.virtual_memory().percent if hasattr(psutil, "virtual_memory") else 0
    )
    cpu_usage = psutil.cpu_percent(interval=1) if hasattr(psutil, "cpu_percent") else 0
    ts = time.time()
    return {
        "status": "healthy",
        "service": "hestia-api",
        "timestamp": ts,
        "version": "0.1.0",
        "uptime": uptime,
        "memory_usage": memory_usage,
        "cpu_usage": cpu_usage,
    }


@router.get("/health/simple")
async def simple_health_check() -> Dict[str, str]:
    """Simple health check endpoint"""
    return {"status": "ok"}
