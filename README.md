# UHF Server – Docker Setup

[![Repo](https://img.shields.io/badge/repo-1.3.0-purple.svg)](CHANGELOG.md)
[![UHF Server](https://img.shields.io/badge/uhf_server-1.3.0-orange.svg)](https://github.com/swapplications/uhf-server-dist)
[![FFmpeg](https://img.shields.io/badge/ffmpeg-7.1.1-green.svg)](https://ffmpeg.org/)
[![Docker](https://img.shields.io/badge/Docker-uhf--1.3.0--ffmpeg7.1.1--d1-blue?logo=docker)](https://hub.docker.com/r/solidpixel/uhf-server/tags)

Run the [UHF Recording Server](https://www.uhfapp.com/server) using Docker. No manual setup, no system-level dependencies — just `docker compose up` and visit port 8000 (or your custom port).

---

## Table of Contents

- ✨ [Features](#-features)
- 📋 [Requirements](#-requirements)
- 🚀 [Getting Started](#-getting-started)
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

Clone this repo and run:

```bash
git clone https://github.com/solid-pixel/uhf-server-docker
cd uhf-server-docker
docker compose up -d    # Will automatically pull image from Docker Hub
```

Then open UHF, go to the Recordings tab, and add:

- SERVER ADDRESS: `<your-host-ip>`
- SERVER PORT: `8000` (or the port you set up in `docker-compose.yml`)

That's it! No building required. 

---

## ⚙️ Customization

The following environment variables can be configured in `docker-compose.yml`:
- **API_HOST**: Bind to all interfaces (default: `0.0.0.0`)
- **API_PORT**: Default API port inside container (default: `8000`) - changing this might break healthchecks
- **RECORDINGS_DIR**: Location for recordings (default: `/var/lib/uhf-server/recordings`)
- **DB_PATH**: Path to database file (default: `/var/lib/uhf-server/db.json`)
- **LOG_LEVEL**: Logging verbosity (default: `INFO`) - (DEBUG, INFO, WARNING, ERROR, CRITICAL)

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
