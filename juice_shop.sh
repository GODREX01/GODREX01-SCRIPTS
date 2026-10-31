#!/usr/bin/env bash
# juice_shop_docker.sh
# Setup OWASP Juice Shop using Docker on Kali Linux

set -euo pipefail
IFS=$'\n\t'

echo "===== OWASP Juice Shop Docker Setup ====="

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

# --- Pull Juice Shop Docker image ---
echo "==> Pulling OWASP Juice Shop Docker image..."
docker pull bkimminich/juice-shop:latest

# --- Ask user for container name and port ---
read -rp "Enter container name [juice_shop]: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-juice_shop}

read -rp "Enter host port to map Juice Shop (default 3000): " HOST_PORT
HOST_PORT=${HOST_PORT:-3000}

# --- Run Juice Shop container ---
# Remove existing container if it exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}\$"; then
    echo "==> Removing existing container..."
    docker rm -f "$CONTAINER_NAME"
fi

echo "==> Running Juice Shop container..."
docker run -d --name "$CONTAINER_NAME" -p "${HOST_PORT}:3000" bkimminich/juice-shop:latest

echo
echo "===== OWASP Juice Shop Docker Setup Complete ====="
echo "Open in browser: http://127.0.0.1:${HOST_PORT}"
echo "Default admin login available in the app (register your own admin account if needed)"
echo
echo "To stop the container: docker stop ${CONTAINER_NAME}"
echo "To start again: docker start ${CONTAINER_NAME}"
