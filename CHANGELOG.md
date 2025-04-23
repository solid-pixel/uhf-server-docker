# Changelog

<!-- Add your changes below. Most recent at the top. -->
## Version 1.2.3 – 2025-04-23

#### ⚠️ Breaking Changes
- Switched from host network mode to port mapping (8000:8000) to improve compatibility with non-Linux systems. If you were using a custom port, you'll need to update the `ports` section in docker-compose.yml

#### Docker Changes
- Updated FFmpeg to version 7.0.2
- Added container health monitoring via `/server/stats` endpoint (built into image)

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
