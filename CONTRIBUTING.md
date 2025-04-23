# Contributing to UHF Server Docker

Thank you for your interest in contributing to the UHF Server Docker project! This document provides guidelines and steps for contributing.

## Development Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Version Management

This project uses semantic versioning with the following structure:
- Repository version (e.g., 1.2.3): Used for releases and git tags
- UHF server version (e.g., 1.2.0): Version of the UHF server being installed
- FFmpeg version (e.g., 7.0.2): Version of FFmpeg being built
- Docker image version: Automatically generated as `${UHF_VERSION}-ffmpeg${FFMPEG_VERSION}`

### Updating Versions

1. Edit `versions.env` to update the relevant versions:
   ```env
   REPO_VERSION=1.2.3          # Repository version
   UHF_VERSION=1.2.0          # UHF server version
   FFMPEG_VERSION=7.0.2       # FFmpeg version
   ```

   The Docker image version will be automatically generated as `1.2.0-ffmpeg7.0.2`.

2. Run the documentation update script:
   ```bash
   ./scripts/update-docs.sh
   ```
   This will:
   - Update the version badges in README.md
   - Add a new changelog entry if `REPO_VERSION` has changed
   - Generate a new changelog entry with:
     - Current date
     - UHF server version update
     - FFmpeg version update

3. Review the changes in README.md and modify the changelog entry if needed.

4. Commit your changes with a descriptive message:
   ```bash
   git add .
   git commit -m "[1.2.3] Your descriptive message"
   ```

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
- For version updates: `[1.2.3] Update FFmpeg to 7.0.2`
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
git commit -m "[1.2.3] Update FFmpeg to 7.0.2"

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
