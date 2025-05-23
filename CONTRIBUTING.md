# Contributing to UHF Server Docker

Thank you for your interest in contributing to the UHF Server Docker project! This document provides guidelines and steps for contributing.

## Development Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Version Management

This project uses semantic versioning.  
**Version numbers will be assigned by maintainers after merge**, so you don't need to update version numbers in your PR.

When submitting a PR:
1. Document your changes in `CHANGELOG.md` under a temporary heading (e.g., "## Unreleased")
2. Note any breaking changes in your PR description
3. The maintainers will handle version bumps, tagging, and changelog organization after merging

## Building and Testing

### Local Testing
```bash
# Build and run locally
docker compose up --build

# Test the container
curl http://localhost:8000/server/stats
```

### Production Releases

The project uses separate scripts for preparing and tagging releases:

```bash
# 1. First update versions in .dev/versions.env
vim .dev/versions.env

# 2. Prepare release (updates badges, docker-compose.yml, and changelog)
./.dev/prepare-release.sh
# The script will pause for you to edit the changelog manually.

# 3. Open a pull request and merge it.

# 4. Build and push Docker images (must be done before tagging)
./.dev/build-docker.sh

# 5. After images are online, create and push the Git tag
./.dev/tag-release.sh
```

The scripts handle different parts of the release process:
- `prepare-release.sh` updates documentation, badges, docker-compose.yml, and adds a changelog entry
- `build-docker.sh` builds and pushes multi-arch Docker images (before tagging)
- `tag-release.sh` creates and pushes the Git tag (after Docker images are online)

Docker images are pushed with these tags:
- `solidpixel/uhf-server:latest`
- `solidpixel/uhf-server:<IMAGE_TAG>` (where `<IMAGE_TAG>` includes UHF version, FFmpeg version, and optional Docker revision, e.g., `uhf-1.3.0-ffmpeg7.1.1-d1`)

## Pull Request Guidelines

1. Include a clear description of the changes
2. Update documentation as needed
3. Add appropriate labels
4. Reference any related issues

## Commit Messages

### Format
Format your commit messages as follows:
- For documentation: `docs: Update installation guide`
- For build changes: `build: Update Dockerfile dependencies`
- For general changes: `chore: Update .gitignore`
- For features: `feat: Add new environment variable`
- For fixes: `fix: Correct port mapping`

### Examples
```bash
# Changes that need Docker rebuild:
git commit -m "build: Update Dockerfile dependencies"

# Changes that don't need Docker rebuild:
git commit -m "docs: Update installation guide"
```

## Need Help?

Feel free to open an issue for:
- Bug reports
- Feature requests
- Questions about the codebase
- Documentation improvements
