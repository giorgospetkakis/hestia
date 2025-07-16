FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_VERSION=3.16.0
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=$FLUTTER_HOME/bin:$PATH

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    python3 \
    python3-pip \
    python3-venv \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME
RUN flutter doctor
RUN flutter config --enable-web

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY backend/requirements.txt ./backend/

# Install Python dependencies
RUN cd backend && python3 -m pip install -r requirements.txt

# Copy Flutter pubspec files
COPY frontend/pubspec.yaml frontend/pubspec.lock ./frontend/

# Install Flutter dependencies
RUN cd frontend && flutter pub get

# Copy the rest of the application
COPY . .

# Build Flutter web app
RUN cd frontend && flutter build web --release --base-href /

# Create public directory and copy Flutter build
RUN mkdir -p public && cp -r frontend/build/web/* public/

# Debug: Check if build was successful
RUN ls -la public/ || echo "Build failed - public directory is empty"
RUN ls -la frontend/build/web/ || echo "Flutter build directory not found"

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Make scripts executable
RUN chmod +x scripts/start.sh scripts/test-health.sh

# Expose port
EXPOSE 80

# Start the application
CMD ["bash", "scripts/start.sh"] 