#!/usr/bin/env bash
# dvwa_docker.sh
# Setup DVWA using Docker on Kali Linux

set -euo pipefail
IFS=$'\n\t'

echo "===== DVWA Docker Setup ====="

# --- Check for root ---
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# --- Install Docker if missing ---
if ! command -v docker >/dev/null 2>&1; then
    echo "==> Installing Docker..."
    apt update -y
    apt install -y docker.io docker-compose
    systemctl enable --now docker
fi

# --- Pull DVWA Docker image ---
echo "==> Pulling DVWA Docker image..."
docker pull vulnerables/web-dvwa:latest

# --- Ask user for container name and port ---
read -rp "Enter container name [dvwa]: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-dvwa}

read -rp "Enter host port to map DVWA (default 80): " HOST_PORT
HOST_PORT=${HOST_PORT:-80}

# --- Run DVWA container ---
# Remove existing container if it exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}\$"; then
    echo "==> Removing existing container..."
    docker rm -f "$CONTAINER_NAME"
fi

echo "==> Running DVWA container..."
docker run -d --name "$CONTAINER_NAME" -p "${HOST_PORT}:80" vulnerables/web-dvwa:latest

echo
echo "===== DVWA Docker Setup Complete ====="
echo "Open in browser: http://127.0.0.1:${HOST_PORT}"
echo "Login: admin / password"
echo "All labs are ready. No host PHP required."
echo
echo "To stop the container: docker stop ${CONTAINER_NAME}"
echo "To start again: docker start ${CONTAINER_NAME}"
