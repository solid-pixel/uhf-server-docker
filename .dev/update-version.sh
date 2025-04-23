#!/bin/bash

# Source versions
source "$(dirname "$0")/versions.env"

# Generate Docker image version
DOCKER_VERSION="${UHF_VERSION}-ffmpeg${FFMPEG_VERSION}"

# Path to files
README_PATH="$(dirname "$0")/../README.md"
COMPOSE_PATH="$(dirname "$0")/../docker-compose.yml"
CHANGELOG_PATH="$(dirname "$0")/../CHANGELOG.md"

# Function to update badge
update_badge() {
    local name="$1"
    local version="$2"
    local color="$3"
    sed -i '' "s|${name}-[^-]*-${color}\.svg|${name}-${version}-${color}.svg|g" "$README_PATH"
}

# Update badges
update_badge "repo" "$REPO_VERSION" "purple"
update_badge "uhf_server" "$UHF_VERSION" "orange"
update_badge "ffmpeg" "$FFMPEG_VERSION" "green"

# Update docker-compose.yml version
sed -i '' "s|solidpixel/uhf-server:[^[:space:]]*|solidpixel/uhf-server:${DOCKER_VERSION}-test|g" "$COMPOSE_PATH"

# Update changelog if new version
if ! grep -q "## Version ${REPO_VERSION}" "$CHANGELOG_PATH"; then
    # Get current date in YYYY-MM-DD format
    TODAY=$(date +%Y-%m-%d)
    
    # Create new changelog entry
    NEW_ENTRY="## Version ${REPO_VERSION} – ${TODAY}\n\n#### Changes\n- Updated UHF server to version ${UHF_VERSION}\n- Updated FFmpeg to version ${FFMPEG_VERSION}\n\n"
    
    # Insert after comment line
    awk -v entry="$NEW_ENTRY" '/<!-- Add your changes below. Most recent at the top. -->/{print;print entry;next}1' "$CHANGELOG_PATH" > "$CHANGELOG_PATH.tmp" && mv "$CHANGELOG_PATH.tmp" "$CHANGELOG_PATH"
fi

echo "Documentation updated successfully!"
