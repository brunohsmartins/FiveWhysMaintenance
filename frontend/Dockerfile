# Dockerfile.frontend
# Stage 1: Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:3.32.4 AS builder

WORKDIR /app
COPY . .
RUN flutter pub get && flutter build web --release

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Remove default content
RUN rm -rf /usr/share/nginx/html/*

# Copy built web content
COPY --from=builder /app/build/web /usr/share/nginx/html

# copia a nossa configuração customizada
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
