# Vercel serverless function entry point
import sys
import os

# Add backend to Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend'))

# Import the FastAPI app from backend
from backend import app

# Export the app for Vercel
handler = app 