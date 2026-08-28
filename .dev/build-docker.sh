#!/bin/bash
set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Load versions
source "${SCRIPT_DIR}/versions.env"

# Build image tag
if [ -n "$DOCKER_REVISION" ]; then
    IMAGE_TAG="uhf-${UHF_VERSION}-ffmpeg${FFMPEG_VERSION}-${DOCKER_REVISION}"
else
    IMAGE_TAG="uhf-${UHF_VERSION}-ffmpeg${FFMPEG_VERSION}"
fi

# Build and push multi-arch image
echo -e "\n${BLUE}🏗️  Building and pushing for ${YELLOW}amd64, arm64${BLUE} with version ${YELLOW}${IMAGE_TAG}${NC}..."

# Ensure buildx builder exists and supports multi-arch
docker buildx create --use --name multiarch-builder 2>/dev/null || docker buildx use multiarch-builder
docker buildx inspect --bootstrap

# Build multi-arch image
docker buildx build \
    --pull \
    --no-cache \
    --platform linux/amd64,linux/arm64 \
    --build-arg UHF_VERSION="${UHF_VERSION}" \
    -f "${REPO_ROOT}/Dockerfile.uhf" \
    -t "solidpixel/uhf-server:${IMAGE_TAG}" \
    -t "solidpixel/uhf-server:latest" \
    --push \
    "${REPO_ROOT}"

echo -e "\n${GREEN}✨ Done! Docker images:${NC}"
echo -e "${BLUE}📦 solidpixel/uhf-server:${YELLOW}${IMAGE_TAG}${NC}"
echo -e "${BLUE}📦 solidpixel/uhf-server:${YELLOW}latest${NC}\n"

# Ask to clean up local images
echo -e "${BLUE}🧹 Clean up local images?${NC}"
echo -e "${YELLOW}This will remove the following images from your laptop:${NC}"
echo -e "  ${BLUE}• solidpixel/uhf-server:${YELLOW}${IMAGE_TAG}${NC}"
echo -e "  ${BLUE}• solidpixel/uhf-server:${YELLOW}latest${NC}"
read -p "$(echo -e ${BLUE}Delete these images? [y/N]${NC} )" -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${BLUE}🗑️  Removing local images...${NC}"
    docker rmi "solidpixel/uhf-server:${IMAGE_TAG}" "solidpixel/uhf-server:latest" 2>/dev/null || true
    echo -e "${GREEN}✨ Cleanup complete!${NC}\n"
else
    echo -e "\n${BLUE}ℹ️  Keeping local images${NC}\n"
fi
