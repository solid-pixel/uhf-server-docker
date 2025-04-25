# Contributing to UHF Server Docker

Thank you for your interest in contributing to the UHF Server Docker project! This document provides guidelines and steps for contributing.

## Development Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Version Management

This project uses semantic versioning. Version numbers will be assigned by maintainers at merge time, so you don't need to update version numbers in your PR.

When submitting a PR:
1. Document your changes in CHANGELOG.md under a temporary heading (e.g., "## Unreleased")
2. Note any breaking changes in your PR description
3. The maintainers will handle version bumps and changelog organization during merge

## Building and Testing

### Local Testing
```bash
# Build and run locally
docker compose up --build

# Test the container
curl http://localhost:8000/server/stats
```

### Production Releases

The project uses two scripts for releases:

```bash
# 1. First update versions in .dev/versions.env
vim .dev/versions.env

# 2. Create release (updates docs, changelog, and creates git tag)
./.dev/release.sh
# The script will pause for you to edit the changelog

# 3. Build and push Docker images (if needed)
./.dev/build-docker.sh
```

The scripts handle different aspects of the release:
- `release.sh` updates documentation, creates changelog entry, and creates git tag
- `build-docker.sh` builds and pushes multi-arch Docker images

The Docker images will be pushed to Docker Hub with these tags:
- `solidpixel/uhf-server:latest`
- `solidpixel/uhf-server:<IMAGE_TAG>` (version tag including optional `-DOCKER_REVISION`, e.g. `uhf-1.2.0-ffmpeg7.0.2-d2`)

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
