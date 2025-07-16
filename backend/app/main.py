from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import time

# Import routers
from app.api.meals.router import router as meals_router
from app.api.health.router import router as health_router

app = FastAPI(
    title="Hestia API",
    description="AI-powered nutrition assistant API",
    version="0.1.0",
)

# Add CORS middleware with more permissive settings for development
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",  # Local development
        "http://localhost:8080",  # Local development
        "http://localhost:3001",  # Alternative local port
        "http://127.0.0.1:3000",  # Local development with IP
        "http://127.0.0.1:8080",  # Local development with IP
        "https://*.vercel.app",   # Vercel deployments
        "https://*.railway.app",  # Railway deployments
        "*",  # Allow all origins in development (remove in production)
    ],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allow_headers=["*"],
    expose_headers=["*"],
)

# Include routers
app.include_router(meals_router)
app.include_router(health_router)

@app.get("/")
async def root():
    """Root endpoint - redirects to health check"""
    return {
        "message": "Hestia API is running", 
        "health": "/health",
        "docs": "/docs",
        "meals": "/api/meals"
    }