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

# Make sure we are on main
git -C "$REPO_ROOT" checkout main
git -C "$REPO_ROOT" pull --ff-only origin main

if git -C "$REPO_ROOT" rev-parse --verify --quiet "refs/tags/${REPO_VERSION}" >/dev/null; then
    echo -e "${RED}Tag ${REPO_VERSION} already exists. Refusing to overwrite it.${NC}"
    exit 1
fi

# Create and push git tag
echo -e "\n${BLUE}🏷️  Tagging version ${YELLOW}${REPO_VERSION}${NC}..."
git -C "$REPO_ROOT" tag -a "${REPO_VERSION}" -m "Release ${REPO_VERSION}"
git -C "$REPO_ROOT" push origin "${REPO_VERSION}"

echo -e "\n${GREEN}✅ Git tag ${YELLOW}${REPO_VERSION}${GREEN} created and pushed.${NC}"
echo -e "\n${BLUE}ℹ️  Publish GitHub release ${YELLOW}${REPO_VERSION}${BLUE} after confirming the Docker images are online.${NC}\n"
