# Rehome

A new project to get started.

## Getting Started

This repository was initialized in GitHub Codespaces.

## About

More details about this project will be added here.

## Developing in WSL2/macOS/Linux

### Prerequisites

- Keep the repo in WSL Linux FS (e.g., `~/workspace`), not `/mnt/c`.
- First-time setup:
  - `bash scripts/bootstrap-linux.sh`
  - Configure git for line endings:
    ```
    git config --global core.autocrlf false
    git config --global core.safecrlf warn
    git add --renormalize .
    git commit -m "Normalize line endings to LF" # if changes exist
    ```

### Running Services

- Backend: `cd backend && composer install && php artisan key:generate && php artisan migrate --seed && composer run dev`
- Frontend: `cd frontend && pnpm install && pnpm dev`

### Default URLs

- Next.js: http://localhost:3000
- API/Admin: http://localhost:8000 (/admin)
- Storybook: http://localhost:6006

### Troubleshooting

If hot reload is flaky, ensure inotify limits (script above), bind to 0.0.0.0, and store code on Linux FS.