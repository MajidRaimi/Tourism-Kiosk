# Docker Deployment Guide for Tourism Kiosk

## Build and Run Instructions

### 1. Build the Docker Image
```bash
docker build -t tourism-kiosk:latest .
```

### 2. Run the Container
```bash
docker run -d \
  --name tourism-kiosk \
  -p 8080:80 \
  --restart unless-stopped \
  -e TZ=Asia/Riyadh \
  tourism-kiosk:latest
```

### 3. Access the Application
Open your browser and navigate to: `http://localhost:8080`

## Docker Commands Reference

### View logs
```bash
docker logs tourism-kiosk
```

### Stop the container
```bash
docker stop tourism-kiosk
```

### Start the container
```bash
docker start tourism-kiosk
```

### Remove the container
```bash
docker rm tourism-kiosk
```

### Check container health
```bash
docker ps
```

## Production Deployment

For production deployment, consider:

1. **Using HTTPS**: Place the container behind a reverse proxy (nginx, Traefik, etc.) with SSL certificates
2. **Custom Port**: Change `-p 8080:80` to your desired port mapping
3. **Resource Limits**: Add resource constraints:
   ```bash
   docker run -d \
     --name tourism-kiosk \
     -p 80:80 \
     --restart always \
     --memory="512m" \
     --cpus="0.5" \
     tourism-kiosk:latest
   ```

## Environment Variables

- `TZ`: Timezone setting (default: Asia/Riyadh)

## Notes

- The application uses Open-Meteo API for weather data (no API key required)
- Prayer times are calculated using the Adhan library
- All assets and localization files are bundled in the Docker image
- The image size is optimized using multi-stage build (~25-30MB final size)