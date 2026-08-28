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

# Source versions
source "${SCRIPT_DIR}/versions.env"

# Generate Docker image version (includes optional patch revision)
if [ -n "$DOCKER_REVISION" ]; then
    DOCKER_VERSION="uhf-${UHF_VERSION}-ffmpeg${FFMPEG_VERSION}-${DOCKER_REVISION}"
else
    DOCKER_VERSION="uhf-${UHF_VERSION}-ffmpeg${FFMPEG_VERSION}"
fi

# Path to files
README_PATH="${REPO_ROOT}/README.md"
COMPOSE_PATH="${REPO_ROOT}/docker-compose.yml"
CHANGELOG_PATH="${REPO_ROOT}/CHANGELOG.md"

# Function to update badge
update_badge() {
    local name="$1"
    local version="$2"
    local color="$3"
    sed -i '' "s|${name}-[^-]*-${color}\.svg|${name}-${version}-${color}.svg|g" "$README_PATH"
}

# Docker badge messages escape hyphens as double hyphens for Shields.io.
update_docker_badge() {
    local badge_version="${DOCKER_VERSION//-/--}"
    sed -E -i '' "s|badge/Docker-[^?]+-blue\\?logo=docker|badge/Docker-${badge_version}-blue?logo=docker|g" "$README_PATH"
}

echo -e "\n${BLUE}🚀 Preparing release ${YELLOW}${REPO_VERSION}${NC}..."

# Update badges
echo -e "\n${BLUE}🎯 Updating badges...${NC}"
update_badge "repo" "$REPO_VERSION" "purple"
update_badge "uhf_server" "$UHF_VERSION" "orange"
update_badge "ffmpeg" "$FFMPEG_VERSION" "green"
update_docker_badge

# Update docker-compose.yml version
echo -e "\n${BLUE}📝 Updating docker-compose.yml...${NC}"
sed -i '' "s|solidpixel/uhf-server:[^[:space:]]*|solidpixel/uhf-server:${DOCKER_VERSION}|g" "$COMPOSE_PATH"

# Update changelog if new version
if ! grep -q "## Version ${REPO_VERSION}" "$CHANGELOG_PATH"; then
    echo -e "\n${BLUE}📋 Adding new changelog entry...${NC}"
    # Get current date in YYYY-MM-DD format
    TODAY=$(date +%Y-%m-%d)
    
    # Create new changelog entry
    NEW_ENTRY="## Version ${REPO_VERSION} – ${TODAY}\n\n#### Changes\n- \n\n"
    
    # Insert after comment line
    awk -v entry="$NEW_ENTRY" '/<!-- Add your changes below. Most recent at the top. -->/{print;print entry;next}1' "$CHANGELOG_PATH" > "$CHANGELOG_PATH.tmp" && mv "$CHANGELOG_PATH.tmp" "$CHANGELOG_PATH"
    
    echo -e "${GREEN}✅ Added new changelog entry for ${YELLOW}${REPO_VERSION}${NC}"
    echo -e "${YELLOW}⚠️  Please edit CHANGELOG.md to add your changes!${NC}"
    echo -e "${BLUE}Press any key to continue after editing the changelog...${NC}"
    read -n 1
fi

echo -e "\n${GREEN}✨ Done!${NC}"
echo -e "\n${YELLOW}✅ Now open a PR and merge it.${NC}"
echo -e "${BLUE}After merging, run:${NC}"
echo -e "${YELLOW}./.dev/build-docker.sh${NC}"
echo -e "${BLUE}After the images are published and verified, run:${NC}"
echo -e "${YELLOW}./.dev/tag-release.sh${NC} and publish the GitHub release.${NC}\n"
