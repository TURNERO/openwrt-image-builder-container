#!/bin/bash

# Detect the container engine
if command -v podman &> /dev/null; then
    DOCKER_CMD="podman"
elif command -v docker &> /dev/null; then
    DOCKER_CMD="docker"
else
    echo "Error: Neither podman nor docker found."
    exit 1
fi

# Use the variable instead of the command
echo "--- Using engine: $DOCKER_CMD ---"

# 1. Configuration
IMAGE_NAME="openwrt-mesh-builder"
CONTAINER_BIN_PATH="$(pwd)/bin"

# 2. Create the host bin directory if it doesn't exist
mkdir -p "$CONTAINER_BIN_PATH"

echo "--- Building Docker Image ---"
$DOCKER_CMD build -t $IMAGE_NAME .

if [ $? -ne 0 ]; then
    echo "Docker build failed. Exiting."
    exit 1
fi

echo "--- Running Build Inside Container ---"
# We mount the host's bin folder to the container's /build/bin
$DOCKER_CMD run --rm -v "$CONTAINER_BIN_PATH":/build/bin $IMAGE_NAME

echo "--- Process Finished ---"
echo "Check the './bin' folder for your new firmware images."
