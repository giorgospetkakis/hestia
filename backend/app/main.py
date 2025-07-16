from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import os

app = FastAPI(
    title="Hestia API",
    description="AI-powered nutrition assistant API",
    version="0.1.0",
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static files (Flutter web build)
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/")
async def root():
    """Serve the Flutter web app index.html"""
    return FileResponse("static/index.html")

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "hestia-api"}

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

# Catch-all route for Flutter web app (SPA routing)
@app.get("/{full_path:path}")
async def serve_flutter_app(full_path: str):
    """Serve Flutter web app for all non-API routes"""
    # Don't serve API routes
    if full_path.startswith("api/"):
        return {"error": "Not found"}, 404
    
    # Try to serve the file if it exists
    file_path = f"static/{full_path}"
    if os.path.exists(file_path):
        return FileResponse(file_path)
    
    # Fallback to index.html for SPA routing
    return FileResponse("static/index.html")
