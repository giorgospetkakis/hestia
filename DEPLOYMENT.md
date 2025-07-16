# Hestia Deployment Guide

## Backend Deployment (Railway)

### 1. Deploy Backend to Railway

1. **Navigate to the backend directory:**
   ```bash
   cd backend
   ```

2. **Deploy to Railway:**
   ```bash
   railway login
   railway init
   railway up
   ```

3. **Get your Railway URL:**
   - Go to your Railway dashboard
   - Copy the generated URL (e.g., `https://hestia-backend-xxxx.up.railway.app`)

### 2. Update Frontend Configuration

Update the production API URL in `frontend/lib/config/app_config.dart`:

```dart
static const String _prodApiUrl = 'https://your-railway-backend-url.up.railway.app';
```

## Frontend Deployment (Vercel)

### 1. Deploy Frontend to Vercel

1. **Navigate to the frontend directory:**
   ```bash
   cd frontend
   ```

2. **Deploy to Vercel:**
   ```bash
   vercel login
   vercel --prod
   ```

3. **Follow the prompts:**
   - Link to existing project or create new
   - Confirm build settings

### 2. Environment Variables (Optional)

If you need to set environment variables in Vercel:
- Go to your Vercel project dashboard
- Navigate to Settings > Environment Variables
- Add any required variables

## Testing the Deployment

1. **Test Backend:**
   - Visit: `https://your-railway-backend-url.up.railway.app/health`
   - Should return: `{"status":"healthy","service":"hestia"}`

2. **Test Frontend:**
   - Visit your Vercel URL
   - Should show the Flutter app
   - Check that it can connect to the backend API

## Benefits of This Approach

✅ **Better Performance:** Vercel's CDN for static files  
✅ **Easier Debugging:** Separate logs for frontend and backend  
✅ **Independent Scaling:** Scale frontend and backend separately  
✅ **Better Reliability:** If one service fails, the other continues  
✅ **Easier Updates:** Deploy frontend and backend independently  

## Troubleshooting

### Backend Issues
- Check Railway logs: `railway logs`
- Verify health endpoint is working
- Check environment variables

### Frontend Issues
- Check Vercel build logs
- Verify API URL is correct
- Check browser console for errors

### CORS Issues
- Ensure backend allows requests from Vercel domain
- Check API service configuration 