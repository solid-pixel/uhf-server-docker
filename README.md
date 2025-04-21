# UHF Server – Docker Setup

[![Repo](https://img.shields.io/badge/repo-1.1.0-purple.svg)](#changelog)
[![UHF Server](https://img.shields.io/badge/uhf_server-1.1.0-orange.svg)](https://github.com/swapplications/uhf-server-dist)
[![Updated](https://img.shields.io/badge/updated-2025--04--21-blue.svg)](#changelog)

Run the [UHF Recording Server](https://www.uhfapp.com/server) using Docker. No manual setup, no system-level dependencies — just `docker compose up`.

---

## ✨ Features

- Fully self-hosted UHF server
- `uhf-server` script bundled in (https://github.com/swapplications/uhf-server-dist)
- Docker + Compose setup (no system install required)
- `unzip` and `ffmpeg` bundled in
- Persistent volume for recordings

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

## 📁 Folder Structure

```
uhf-server-docker/
├── docker-compose.yml      # Container config (uses pre-built image)
└── uhf-data/               # Persistent recordings & database
```

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

---

## 👥 Credits

- [UHF Server](https://www.uhfapp.com) by Swapplications
- Docker wrapper by [Alessandro Benassi](https://github.com/solid-pixel)

---

## 📜 License

MIT — do what you want, no warranty

---

## 📝 Changelog

<!-- Add your changes below. Most recent at the top. -->

<details open>
<summary><strong>Version 1.1.0</strong> – 2025-04-21</summary>

#### Docker Image Changes
- Published image to Docker Hub (`solidpixel/uhf-server:1.1.0`)

#### Repository Changes
- Added Docker Hub run instructions to README
- Improved Docker workflow and documentation
- Restructured README for better clarity
</details>

<details>
<summary><strong>Version 1.0.0</strong></summary>

Initial release
</details>
