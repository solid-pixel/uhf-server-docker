# UHF Server – Docker Setup

[![Repo](https://img.shields.io/badge/repo-2.0.0-purple.svg)](CHANGELOG.md)
[![UHF Server](https://img.shields.io/badge/uhf_server-2.0.0-orange.svg)](https://github.com/swapplications/uhf-server-dist)
[![FFmpeg](https://img.shields.io/badge/ffmpeg-7.1.1-green.svg)](https://ffmpeg.org/)
[![Docker](https://img.shields.io/badge/Docker-uhf--2.0.0--ffmpeg7.1.1--d1-blue?logo=docker)](https://hub.docker.com/r/solidpixel/uhf-server/tags)

Run the [UHF Recording Server](https://www.uhfapp.com/server) using Docker. No manual setup, no system-level dependencies — just `docker compose up` and visit port 8000 (or your custom port).

---

## Table of Contents

- ✨ [Features](#-features)
- 📋 [Requirements](#-requirements)
- 🚀 [Getting Started](#-getting-started)
- ⬆️ [Upgrading to 2.0.0](#upgrading-to-200)
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

---

## 📋 Requirements

- Docker
- Docker Compose v2+

---

> ⚠️ **Disclaimer:** 
This Docker wrapper is _not officially developed or maintained_ by Swapplications (the creators of UHF Server).  
> I'm not affiliated with them — I just built this to make deployment easier for the community.  
>  
> I do **not** maintain the `uhf-server` script itself — only the Docker setup.  
> If you run into issues with the actual recording logic or the server code, you'll need to contact the UHF devs directly.  
>  
> For bugs, suggestions, or Docker-related issues, please **open an Issue or PR on GitHub**. Reddit and Discord DMs won't be monitored.

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

## Upgrading to 2.0.0

UHF Server 2 records new programs as HLS playlists and segments. Existing legacy single-file recordings remain supported.

Before upgrading, back up the complete `uhf-data` directory. Then pull or recreate the container so Compose uses `solidpixel/uhf-server:uhf-2.0.0-ffmpeg7.1.1-d1` while retaining the existing `./uhf-data:/var/lib/uhf-server` mount:

```bash
docker compose pull
docker compose up -d --force-recreate
```



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
- Docker wrapper by [Alessandro Benassi](https://github.com/solid-pixel)
- All the Discord legends that helped me test this

---

## 📜 License

MIT — do what you want, no warranty

---

## 🕧 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
