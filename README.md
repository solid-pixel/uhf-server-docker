# UHF Server – Docker Setup

[![Repo](https://img.shields.io/badge/repo-1.2.3-purple.svg)](CHANGELOG.md)
[![UHF Server](https://img.shields.io/badge/uhf_server-1.2.0-orange.svg)](https://github.com/swapplications/uhf-server-dist)
[![FFmpeg](https://img.shields.io/badge/ffmpeg-7.0.2-green.svg)](https://ffmpeg.org/)
[![Updated](https://img.shields.io/badge/updated-2025--04--23-blue.svg)](CHANGELOG.md)

Run the [UHF Recording Server](https://www.uhfapp.com/server) using Docker. No manual setup, no system-level dependencies — just `docker compose up`.

---

## ✨ Features

- Fully containerized [UHF Server](https://github.com/swapplications/uhf-server-dist)
- FFmpeg
- Docker + Compose setup (no system install required)
- Persistent volume for recordings
- Multi-arch support (amd64, arm64)
- Container health monitoring

---

## 📋 Requirements

- Docker
- Docker Compose v2+

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

- **API_HOST**: Server listen address (default: `0.0.0.0`)
- **API_PORT**: Server port (default: `8000`)
- **RECORDINGS_DIR**: Path to recordings inside container (default: `/var/lib/uhf-server/recordings`)
- **DB_PATH**: Path to database file inside container (default: `/var/lib/uhf-server/db.json`)
- **LOG_LEVEL**: Logging verbosity (default: `INFO`)

You can also customize:
- **Storage location:** adjust the `volumes:` path in `docker-compose.yml`
- **Auto-restart:** enabled via `restart: unless-stopped` in `docker-compose.yml`
- **Health checks:** container health is monitored every 30s via `/health` endpoint

---

## 👥 Credits

- [UHF Server](https://www.uhfapp.com) by Swapplications
- Docker wrapper by [Alessandro Benassi](https://github.com/solid-pixel)
- All the Discord legends that helped me test this

---

## 📜 License

MIT — do what you want, no warranty

---

## 🕧 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
