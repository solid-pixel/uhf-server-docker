#!/bin/bash

# Source versions
source "$(dirname "$0")/versions.env"

# Generate Docker image version
DOCKER_VERSION="${UHF_VERSION}-ffmpeg${FFMPEG_VERSION}"

# Path to README and docker-compose.yml
README_PATH="$(dirname "$0")/../README.md"
COMPOSE_PATH="$(dirname "$0")/../docker-compose.yml"

# Function to update badge
update_badge() {
    local name="$1"
    local version="$2"
    local color="$3"
    sed -i '' "s|${name}-[^-]*-${color}|${name}-${version}-${color}|g" "$README_PATH"
}

# Update badges
update_badge "repo" "$REPO_VERSION" "blue"
update_badge "uhf_server" "$UHF_VERSION" "blue"
update_badge "ffmpeg" "$FFMPEG_VERSION" "blue"
update_badge "docker" "$DOCKER_VERSION" "blue"

# Update docker-compose.yml version
sed -i '' "s|solidpixel/uhf-server:[^[:space:]]*|solidpixel/uhf-server:${DOCKER_VERSION}-test|g" "$COMPOSE_PATH"

# Update changelog if new version
if ! grep -q "## Version ${REPO_VERSION}" "$README_PATH"; then
    # Get current date in YYYY-MM-DD format
    TODAY=$(date +%Y-%m-%d)
    
    # Create new changelog entry
    NEW_ENTRY="## Version ${REPO_VERSION} (${TODAY})\n\n- Updated UHF server to version ${UHF_VERSION}\n- Updated FFmpeg to version ${FFMPEG_VERSION}\n\n"
    
    # Insert after changelog header
    awk -v entry="$NEW_ENTRY" '/# Changelog/{print;print entry;next}1' "$README_PATH" > "$README_PATH.tmp" && mv "$README_PATH.tmp" "$README_PATH"
fi

echo "Documentation updated successfully!"
