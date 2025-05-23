# Changelog

<!-- Add your changes below. Most recent at the top. -->
## Version 1.3.0 – 2025-05-20

#### Docker Image Changes
- Updated `uhf-server` to version `1.3.0` ([Changelog](https://github.com/swapplications/uhf-server-dist/blob/main/CHANGELOG.md))

#### Docker Compose Changes
- Update `image` tag to `solidpixel/uhf-server:uhf-1.3.0-ffmpeg7.1.1-d1`


## Version 1.2.6 – 2025-04-29

Fixes [Issue #16](https://github.com/solid-pixel/uhf-server-docker/issues/16)

#### Docker Compose Changes
- Update `image` tag to `solidpixel/uhf-server:uhf-1.2.0-ffmpeg7.1.1-d1`

#### Docker Image Changes
- New Docker image tag: `solidpixel/uhf-server:uhf-1.2.0-ffmpeg7.1.1-d1`
- Updated FFmpeg to standard version `7.1.1` (previously used custom build)
- Switched to `Ubuntu 25.04` (previously used `Debian Bookworm`)

## Version 1.2.5 – 2025-04-25

#### Docker Compose Changes
- Moved healthcheck from Dockerfile into `docker-compose.yml` (monitored via `/server/stats` every 30s)
- Added optional recordings override volume (`./uhf-recordings:/var/lib/uhf-server/recordings`)
- Added comments to `docker-compose.yml` for better onboarding

#### Docker Image Changes
- New Docker image tag: `solidpixel/uhf-server:uhf-1.2.0-ffmpeg7.0.2-d2`
- Removed healthcheck from Dockerfile (now in `docker-compose.yml`)

#### Dev Changes
- Dev: Support optional `DOCKER_REVISION` for patch-level image tags in `.dev/versions.env`
- Dev: Split release process into two separate scripts: `prepare-release.sh` and `tag-release.sh`
- Dev: Updated `build-docker.sh` to build and push multi-arch images automatically
- Dev: Updated contribution guidelines to reflect the new release workflow

#### Documentation Changes
- Updated README with optional recordings mount and healthcheck details
- Updated CONTRIBUTING.md to match the new release process

## Version 1.2.4 – 2025-04-24

#### Internal Changes
> These changes only affect development and maintenance of the project. No action needed for end users.

- Simplified release workflow with two scripts: `release.sh` and `build-docker.sh`
- Moved UHF server installation directly into Dockerfile for better version control
- Removed automated GitHub Actions workflow in favor of manual releases
- Added version-specific UHF server installation (no longer using latest)
- Added colored output and emojis to dev scripts for better UX

## Version 1.2.3 – 2025-04-23

#### ⚠️ Breaking Changes
- Switched from host network mode to port mapping (8000:8000) to improve compatibility with non-Linux systems. If you were using a custom port, you'll need to update the `ports` section in docker-compose.yml

#### Docker Changes
- Updated FFmpeg to version 7.0.2
- Added container health monitoring via `/server/stats` endpoint (built into image)
- Now using version-locked UHF server builds instead of latest

## Version 1.2.0 – 2025-04-22

#### Repository Changes
- Initial release
- Automated builds
- Multi-arch support (amd64, arm64)

## Version 1.1.2 – 2025-04-22

#### Repository Changes
- Fixed GitHub Actions permissions for automated releases

## Version 1.1.1 – 2025-04-22

#### Docker Image Changes
- Added multi-architecture support (amd64, arm64)

#### Repository Changes
- Added GitHub Actions workflow for multi-arch builds
- Updated documentation with architecture support info

## Version 1.1.0 – 2025-04-21

#### Docker Image Changes
- Published image to Docker Hub (`solidpixel/uhf-server:1.1.0`)

#### Repository Changes
- Added Docker Hub run instructions to README
- Switched to environment-based configuration (API_HOST, API_PORT, etc.)
- Improved documentation with customization options
- Restructured README for better clarity

## Version 1.0.0

Initial release
