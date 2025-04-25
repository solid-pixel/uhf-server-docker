#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Load versions
source "$(dirname "$0")/versions.env"

# Build image tag
if [ -n "$DOCKER_REVISION" ]; then
    IMAGE_TAG="uhf-${UHF_VERSION}-ffmpeg${FFMPEG_VERSION}-${DOCKER_REVISION}"
else
    IMAGE_TAG="uhf-${UHF_VERSION}-ffmpeg${FFMPEG_VERSION}"
fi

# Build and push multi-arch image
echo -e "\n${BLUE}🏗️  Building for ${YELLOW}amd64, arm64${BLUE} with version ${YELLOW}${IMAGE_TAG}${NC}..."

docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --build-arg UHF_VERSION="${UHF_VERSION}" \
    -f Dockerfile.uhf \
    -t "solidpixel/uhf-server:${IMAGE_TAG}" \
    -t "solidpixel/uhf-server:latest" \
    .

# Prompt to push images
read -p "$(echo -e ${BLUE}Push images to Docker Hub? [y/N]${NC}) " -n1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${BLUE}🚀 Pushing images...${NC}"
    docker push "solidpixel/uhf-server:${IMAGE_TAG}"
    docker push "solidpixel/uhf-server:latest"
    echo -e "${GREEN}✅ Push complete!${NC}\n"
fi

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