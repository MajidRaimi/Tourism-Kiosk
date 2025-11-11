# Stage 1: Build the Flutter web application
FROM debian:bookworm-slim AS builder

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for Flutter
RUN groupadd -r flutter && useradd -r -g flutter flutter

# Set up Flutter SDK
ENV FLUTTER_VERSION=3.24.5
ENV FLUTTER_HOME=/home/flutter/sdk
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"

# Download and install Flutter as flutter user
USER flutter
WORKDIR /home/flutter

RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME \
    && cd $FLUTTER_HOME \
    && git checkout $FLUTTER_VERSION \
    && flutter doctor -v \
    && flutter channel stable \
    && flutter upgrade \
    && flutter config --enable-web --no-analytics

# Set working directory
WORKDIR /home/flutter/app

# Copy pubspec files first for better caching (as root, then change ownership)
USER root
COPY --chown=flutter:flutter pubspec.yaml pubspec.lock ./

# Switch back to flutter user
USER flutter

# Get Flutter dependencies
RUN flutter pub get

# Copy the entire project (as root, then change ownership)
USER root
COPY --chown=flutter:flutter . .

# Switch back to flutter user for building
USER flutter

# Build the Flutter web application
RUN flutter build web --release

# Stage 2: Serve the application with nginx
FROM nginx:alpine

# Install necessary packages
RUN apk add --no-cache \
    tzdata \
    && rm -rf /var/cache/apk/*

# Copy the built web app from the builder stage
COPY --from=builder /home/flutter/app/build/web /usr/share/nginx/html

# Create a custom nginx configuration
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    root /usr/share/nginx/html; \
    index index.html; \
    \
    location / { \
        try_files $uri $uri/ /index.html; \
        add_header Cache-Control "no-cache, no-store, must-revalidate"; \
        add_header Pragma "no-cache"; \
        add_header Expires "0"; \
    } \
    \
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ { \
        expires 1y; \
        add_header Cache-Control "public, immutable"; \
    } \
    \
    gzip on; \
    gzip_vary on; \
    gzip_min_length 1024; \
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json; \
}' > /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]