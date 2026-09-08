# pi-docker

Docker image for the [pi coding agent](https://github.com/mariozechner/pi-coding-agent) with ttyd support.

## Overview

A standalone Docker image that packages:

- **pi coding agent** — installed globally
- **ttyd** — browser-based terminal access on port 7681
- **Extensions** — installed at runtime via `PI_EXTENSIONS` env var

## Quick Start

```bash
# Build the image
make build

# Run agent interactively in a directory
make run ~/my-project

# Serve via browser (http://localhost:7681)
make serve ~/my-project

# Open a bash shell
make shell ~/my-project
```

## Commands

| Command | Description |
|---|---|
| `make build` | Build the Docker image |
| `make update` | Pull newest base image and rebuild |
| `make refresh` | Rebuild with no cache (after dependency changes) |
| `make run <dir>` | Run pi agent interactively in a directory |
| `make serve <dir>` | Run pi agent via ttyd (browser at http://localhost:7681) |
| `make shell <dir>` | Open a bash shell inside the container |
| `make rm` | Remove the Docker image |

## Extensions

Extensions are configured via the `EXTENSIONS` variable (comma-separated):

```bash
# Default extensions
make run ~/my-project

# Custom extensions
make run EXTENSIONS=npm:pi-observability,npm:pi-web-access,npm:pi-github ~/my-project

# No extensions
make run EXTENSIONS= ~/my-project
```

Extensions are installed at container startup — no rebuild needed.

## Pi Home Directory

Your pi home directory (`~/.pi`) is automatically mounted into the container so settings, extensions, auth, and sessions persist across runs.

The host path can be customized via the `PI_HOME` variable:

```bash
# Custom pi home path
make run PI_HOME=/custom/path/.pi ~/my-project

# Disable mounting pi home entirely
make run PI_HOME= ~/my-project
```

This applies to all commands (`run`, `shell`, `serve`).

## ttyd Configuration

ttyd (the browser-based terminal) can be customized via environment variables:

| Variable | Default | Description |
|---|---|---|
| `TTYD_PORT` | `7681` | Port ttyd listens on |
| `TTYD_THEME` | `theme={"background": "black"}` | ttyd theme options (JSON) |

```bash
# Custom port
make serve TTYD_PORT=8080 ~/my-project

# Custom theme (e.g. dark gray background)
make serve TTYD_THEME='theme={"background": "#1e1e1e"}' ~/my-project

# Both
make serve TTYD_PORT=9000 TTYD_THEME='theme={"background": "#1e1e1e"}' ~/my-project
```

You can also set them directly when running the container:

```bash
docker run -e TTYD_PORT=8080 -e TTYD_THEME='theme={"background": "#1e1e1e"}' ...
```

## Docker Image

The image is published to GitHub Container Registry on every release:

```bash
docker pull ghcr.io/<owner>/pi-docker:latest
docker pull ghcr.io/<owner>/pi-docker:v1.0.0
```

## License

MIT — Copyright (c) 2026 Wiktor Chomik
