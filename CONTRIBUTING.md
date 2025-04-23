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

1. Build the Docker image locally:
   ```bash
   docker buildx build --platform linux/amd64,linux/arm64 -t solidpixel/uhf-server:test -f Dockerfile.uhf .
   ```

2. Test the image:
   ```bash
   docker compose up -d
   ```

3. Check FFmpeg version:
   ```bash
   docker compose exec uhf-server ffmpeg -version
   ```

## Pull Request Guidelines

1. Include a clear description of the changes
2. Update documentation as needed
3. Add appropriate labels
4. Reference any related issues

## Commit Messages and CI/CD

### Format
Format your commit messages as follows:
- For documentation: `docs: Update installation guide`
- For build changes: `build: Update Dockerfile dependencies`
- For general changes: `chore: Update .gitignore`

### CI/CD Control
Add `[skip_build]` to your commit message to skip the CI/CD pipeline. This is useful when:
- Making documentation-only changes
- Updating the changelog
- Making other changes that don't require rebuilding the Docker image

Examples:
```bash
# Changes that need Docker rebuild:
git commit -m "build: Update Dockerfile dependencies"

# Changes that don't need Docker rebuild:
git commit -m "docs: Update installation guide [skip_build]"
git commit -m "chore: Fix typo in changelog [skip_build]"
```

## Need Help?

Feel free to open an issue for:
- Bug reports
- Feature requests
- Questions about the codebase
- Documentation improvements
