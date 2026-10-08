# UHF Server – Docker Setup

[![Repo](https://img.shields.io/badge/repo-2.1.0-purple.svg)](CHANGELOG.md)
[![UHF Server](https://img.shields.io/badge/uhf_server-2.1.0-orange.svg)](https://github.com/swapplications/uhf-server-dist)
[![FFmpeg](https://img.shields.io/badge/ffmpeg-7.1.5-green.svg)](https://ffmpeg.org/)
[![Docker](https://img.shields.io/badge/Docker-uhf--2.1.0--ffmpeg7.1.5--d1-blue?logo=docker)](https://hub.docker.com/r/solidpixel/uhf-server/tags)

Run the [UHF Recording Server](https://www.uhfapp.com/server) using Docker. No manual setup, no system-level dependencies — just `docker compose up` and visit port 8000 (or your custom port).

> **Scope:** This is an independent community project for Docker packaging and deployment. I maintain the Docker image, Compose configuration, and setup documentation. Swapplications develops the UHF app and UHF Server and handles product support, including paid subscriptions.
>
> **Please open issues here only for this repository's Docker setup.** Report UHF app or server bugs and product feature requests to [UHF support](https://getuhf.com/support), even if they occur inside this container. See [Support and issue scope](.github/SUPPORT.md) for examples.

---

## Table of Contents

- ✨ [Features](#-features)
- 📋 [Requirements](#-requirements)
- 🚀 [Getting Started](#-getting-started)
- ⬆️ [Upgrading to 2.1.0](#upgrading-to-210)
- 🌐 [Web interface](#web-interface)
- ⚙️ [Customization](#️-customization)
- 🖥️ [Running on Unraid](#️-running-on-unraid-and-truenas-scale)
- 👥 [Credits](#-credits)
- 📜 [License](#-license)
- 🕧 [Changelog](#-changelog)

---

## ✨ Features

- Fully containerized [UHF Server](https://github.com/swapplications/uhf-server-dist)
- Version-locked UHF server and FFmpeg builds
- Docker + Compose setup (no system install required)
- Persistent volume for recordings
- Multi-arch support (amd64, arm64)
- Container health monitoring
- Commercial detection support (UHF 1.4.0+) — `comskip` pre-installed
- Browser interface for managing, watching, and downloading recordings (UHF 2.1.0+)

---

## 📋 Requirements

- Docker
- Docker Compose v2+

---

> ⚠️ **Disclaimer:**
> This Docker wrapper is _not officially developed or maintained_ by Swapplications (the creators of UHF Server).
>
> I'm not affiliated with them — I just built this to make deployment easier for the community.

> **Support:** For Docker packaging bugs, setup questions, or suggestions about this repository, please **open an Issue or PR on GitHub**. Reddit and Discord DMs won't be monitored. UHF product issues belong with [UHF support](https://getuhf.com/support).

> **Note:** This README and repository are built with Docker Compose in mind. While other methods of running the container may work, they are not officially supported and are up to the user to figure out.

---

## 🚀 Getting Started

1. Clone this repo and start the container:

    ```bash
    # Clone this repo
    git clone https://github.com/solid-pixel/uhf-server-docker

    # Navigate to the directory
    cd uhf-server-docker

    # Start the container
    docker compose up -d
    ```

2. Open UHF, go to the Recordings tab, and add:

    - SERVER ADDRESS: `<your-host-ip>`
    - SERVER PORT: `8000` (or the port you set up in `docker-compose.yml`)

## Upgrading to 2.1.0

UHF Server 2 records new programs as HLS playlists and segments. Existing legacy single-file recordings remain supported.

Wait for active recordings to finish, then back up the complete `uhf-data` directory and any separate recordings mount. Update your Compose file to use `solidpixel/uhf-server:uhf-2.1.0-ffmpeg7.1.5-d1`, retaining the existing `./uhf-data:/var/lib/uhf-server` mount, and run:

```bash
docker compose pull
docker compose up -d --force-recreate
```

## Web interface

Open `http://<your-host-ip>:8000/` (or your custom port) to manage scheduled recordings, browse the library, watch recordings, download them as a single file, and view server logs.

Sign in with the server's `PASSWORD` if you have configured one. Without a password, devices that can reach the server can access the interface directly. No UHF account is required.

See the [upstream 2.1.0 release notes](https://github.com/swapplications/uhf-server-dist/releases/tag/2.1.0) for browser playback compatibility and recording fixes.

---

## ⚙️ Customization

The following environment variables can be configured in `docker-compose.yml`:
- **API_HOST**: Bind to all interfaces (default: `0.0.0.0`)
- **API_PORT**: Default API port inside container (default: `8000`) - changing this might break healthchecks
- **RECORDINGS_DIR**: Location for recordings (default: `/var/lib/uhf-server/recordings`)
- **DB_PATH**: Path to database file (default: `/var/lib/uhf-server/db.json`)
- **LOG_LEVEL**: Logging verbosity (default: `INFO`) - (DEBUG, INFO, WARNING, ERROR, CRITICAL)
- **ENABLE_COMMERCIAL_DETECTION**: Set exactly `true` to enable automatic commercial detection after recordings. `false`, an empty value, or an unset variable leaves it disabled (default: `false`). Uses [`comskip`](https://github.com/erikkaashoek/Comskip), already installed in this image
- **PASSWORD**: (optional) Passes the complete value as one `--password` argument to `uhf-server`, including values containing spaces or shell-sensitive characters

`ENABLE_COMMERCIAL_DETECTION` and `PASSWORD` are passed through by Compose and can be set in three ways. For the other optional variables, first uncomment their entries in `docker-compose.yml`:
1. Directly in the `docker-compose.yml` file (uncomment the environment section)
2. In a `.env` file placed in the same directory as your `docker-compose.yml`
3. As environment variables in your shell before running `docker compose up`

You can also customize:
- **Storage location:** adjust the `volumes:` path in `docker-compose.yml`
- **Port mapping:** change `8000:8000` to `YOUR_PORT:8000` in `docker-compose.yml` to use a different external port
- **Auto-restart:** enabled via `restart: unless-stopped` in `docker-compose.yml`
- **Health checks:** container health is monitored every 30s via `/server/stats` endpoint
- **Recordings folder:** override only the recordings directory by uncommenting `./uhf-recordings:/var/lib/uhf-server/recordings` in `docker-compose.yml` (optional; in addition to the main data mount)

---

## 🖥️ Running on Unraid and TrueNAS SCALE

If you’re not using Docker Compose, make sure to set the container’s command to `uhf-server` manually in the UI. These platforms don’t use `docker-compose.yml`, so the default entrypoint won’t be applied. Without this, the server won’t start.

---

## 👥 Credits

- [UHF Server](https://www.uhfapp.com/server) by Swapplications
- Docker wrapper by [Alessandro Benassi](https://github.com/solid-pixel) ([alebenassi.com](https://alebenassi.com))
- All the Discord legends that helped me test this

---

## 📜 License

MIT — do what you want, no warranty

---

## 🕧 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
