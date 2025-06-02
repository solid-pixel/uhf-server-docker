#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Source versions
source "$(dirname "$0")/versions.env"

# Make sure we are on main
git checkout main
git pull origin main

# Create and push git tag
echo -e "\n${BLUE}🏷️  Tagging version ${YELLOW}${REPO_VERSION}${NC}..."
git tag -f "${REPO_VERSION}"
git push -f origin "${REPO_VERSION}"

echo -e "\n${GREEN}✅ Git tag ${YELLOW}${REPO_VERSION}${GREEN} created and pushed.${NC}"
echo -e "\n${BLUE}ℹ️  Now you can build and push the Docker images by running:${NC}"
echo -e "${YELLOW}./.dev/build-docker.sh${NC}\n"