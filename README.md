# UHF Server – Docker Setup

Run the [UHF Recording Server](https://www.uhfapp.com/server) using Docker. No manual setup, no system-level dependencies — just `docker compose up`.

---

## Features

- Fully self-hosted UHF server
- Docker + Compose setup (no system install required)
- `unzip` and `ffmpeg` bundled in
- Persistent volume for recordings
- Works on any Linux machine (x86_64)

---

## Requirements

- Docker
- Docker Compose v2+

---

## Getting Started

Clone this repo and run:

```bash
git clone https://github.com/solid-pixel/uhf-server-docker
cd uhf-server-docker
docker compose up --build -d
```

Then open UHF, go to the Recordings tab, and add:

- SERVER ADDRESS: `<your-host-ip>`
- SERVER PORT: `8000` (or the port you set up in `docker-compose.yaml`)

---

## Folder Structure

```
uhf-server-docker/
├── docker-compose.yml      # Container config
├── Dockerfile.uhf          # Image build file
└── uhf-data/               # Persistent recordings & database
```

---

## Customization

- **Change port:** edit the `--port` value in `docker-compose.yml`
- **Change storage path:** adjust the `volumes:` path
- **Auto-start:** enabled via `restart: unless-stopped`


---

## Credits

- [UHF Server](https://www.uhfapp.com) by Swapplications
- Docker wrapper by [Alessandro Benassi](https://github.com/solid-pixel)

---

## License

MIT — do what you want, no warranty
