from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import time

app = FastAPI(
    title="Hestia API",
    description="AI-powered nutrition assistant API",
    version="0.1.0",
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",  # Local development
        "http://localhost:8080",  # Local development
        "https://*.vercel.app",   # Vercel deployments
        "https://*.railway.app",  # Railway deployments
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
async def health_check():
    """Health check endpoint for Railway deployment"""
    return {
        "status": "healthy",
        "service": "hestia-api",
        "timestamp": time.time(),
        "version": "0.1.0"
    }

@app.get("/")
async def root():
    """Root endpoint - redirects to health check"""
    return {"message": "Hestia API is running", "health": "/health"}

@app.get("/api/meals")
async def get_meals():
    return {
        "meals": [
            {
                "id": 1,
                "name": "Sample Breakfast",
                "type": "breakfast",
                "description": "A healthy start to your day",
            }
        ]
    }