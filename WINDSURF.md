# Windsurf setup (WSL + Docker)

Follow these steps to open this repo in Windsurf and run the dev stack with Docker.

## 1) Open the repo in Windsurf

Pick one:
- Windows Explorer: open \\wsl$\Ubuntu\home\armando\dev\rehome in Windsurf
- Or in a WSL terminal: use Windsurf to “Open Folder” and select `/home/armando/dev/rehome`

If prompted to “Reopen in Container”, choose No. We use Docker Compose directly.

## 2) Start the stack

First-time setup (build images, prepare env, migrate/seed, etc.):

```bash
bash scripts/docker-setup.sh
```

Subsequent runs:

```bash
docker compose up -d
```

Rebuild the backend image (e.g., after Dockerfile.dev changes):

```bash
docker compose build backend
```

Services:
- Backend (Laravel): http://localhost:8000 (admin at /admin)
- Frontend (Next.js): http://localhost:3000
- PhpMyAdmin: http://localhost:8080
- Mailhog: http://localhost:8025

## 3) PHP debugging (Xdebug)

Xdebug is enabled in the backend dev image via `backend/docker/php.dev.ini`:
- `xdebug.mode = debug`
- `xdebug.start_with_request = yes`
- `xdebug.client_port = 9003`
- `xdebug.client_host = host.docker.internal`

The compose override maps `host.docker.internal` for Linux/WSL.

In Windsurf:
- Enable PHP debugger listening on port 9003.
- Add path mapping: container `/var/www/html` -> local `/home/armando/dev/rehome/backend`.
- Set a breakpoint and hit a route (e.g., http://localhost:8000/admin).

## 4) Frontend dev and debugging (optional)

The frontend runs in Docker with `pnpm dev`. You can:
- Attach a Node debugger to the running container (enable `--inspect=0.0.0.0:9229` if needed), or
- Run the frontend locally if you prefer local dev.

## 5) Troubleshooting

- Build fails installing xdebug: run a clean rebuild
  ```bash
  docker compose build --no-cache backend
  ```
- Ports in use: stop the stack and restart
  ```bash
  docker compose down
  docker compose up -d
  ```
- Breakpoints not hit: confirm Windsurf is listening on 9003 and path mapping is correct.

---
This workflow mirrors the Cursor setup and works the same in Windsurf.
