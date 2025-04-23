#!/bin/bash

# Source versions
source "$(dirname "$0")/../versions.env"

# Generate Docker image version
DOCKER_IMAGE_VERSION="${UHF_VERSION}-ffmpeg${FFMPEG_VERSION}"

# Path to README
README_PATH="$(dirname "$0")/../README.md"

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
update_badge "docker" "$DOCKER_IMAGE_VERSION" "blue"

# Update changelog if new version
if ! grep -q "## Version ${REPO_VERSION}" "$README_PATH"; then
    # Get current date in YYYY-MM-DD format
    TODAY=$(date +%Y-%m-%d)
    
    # Create new changelog entry
    NEW_ENTRY="\n## Version ${REPO_VERSION} (${TODAY})\n\n- Updated UHF server to version ${UHF_VERSION}\n- Updated FFmpeg to version ${FFMPEG_VERSION}\n"
    
    # Insert after changelog header
    sed -i '' "/# Changelog/a\\${NEW_ENTRY}" "$README_PATH"
fi

echo "Documentation updated successfully!"
