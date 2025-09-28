#!/usr/bin/env bash
set -euo pipefail

# Default values
STORYBOOK=false
BACKEND_ONLY=false
FRONTEND_ONLY=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --storybook)
            STORYBOOK=true
            shift
            ;;
        --backend-only)
            BACKEND_ONLY=true
            shift
            ;;
        --frontend-only)
            FRONTEND_ONLY=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --storybook      Start Storybook along with other services"
            echo "  --backend-only   Start only the Laravel backend"
            echo "  --frontend-only  Start only the Next.js frontend"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

echo "🚀 Starting Rehome development servers..."

# Detect Codespaces
IN_CODESPACES=false
if [[ "${CODESPACES:-}" == "true" || -n "${CODESPACE_NAME:-}" ]]; then
    IN_CODESPACES=true
fi

# Build external URLs when in Codespaces
BACKEND_EXT_URL="http://localhost:8000"
FRONTEND_EXT_URL="http://localhost:3000"
STORYBOOK_EXT_URL="http://localhost:6006"
if [[ "$IN_CODESPACES" == true && -n "${CODESPACE_NAME:-}" ]]; then
    BACKEND_EXT_URL="https://${CODESPACE_NAME}-8000.app.github.dev"
    FRONTEND_EXT_URL="https://${CODESPACE_NAME}-3000.app.github.dev"
    STORYBOOK_EXT_URL="https://${CODESPACE_NAME}-6006.app.github.dev"
fi

# Function to start backend
start_backend() {
    echo "🟡 Starting Laravel backend on port 8000..."
    cd backend

    if [[ "$IN_CODESPACES" == true ]]; then
        # Use Codespaces-aware env so asset() & cookies work over the proxy
        APP_URL="$BACKEND_EXT_URL" \
        ASSET_URL="$BACKEND_EXT_URL" \
        SESSION_DRIVER=database \
        SESSION_SECURE_COOKIE=true \
        TRUSTED_PROXIES="*" \
        SANCTUM_STATEFUL_DOMAINS="${CODESPACE_NAME}-8000.app.github.dev,${CODESPACE_NAME}-3000.app.github.dev,localhost,127.0.0.1" \
        php artisan serve --host=0.0.0.0 --port=8000 &
    else
        php artisan serve --host=0.0.0.0 --port=8000 &
    fi

    BACKEND_PID=$!
    cd ..
    echo "Backend PID: $BACKEND_PID"

    # Try to set the port public in Codespaces (best-effort)
    if [[ "$IN_CODESPACES" == true ]]; then
        if command -v gh >/dev/null 2>&1; then
            (gh codespace ports visibility 8000:public -c "${CODESPACE_NAME}" >/dev/null 2>&1 && \
             echo "🌐 Made port 8000 Public in Codespaces") || \
             echo "ℹ️ Could not update port visibility automatically. Use the Ports panel to set 8000 -> Public."
        else
            echo "ℹ️ gh CLI not found. Use the Ports panel to set 8000 -> Public."
        fi
    fi
}

# Function to start frontend
start_frontend() {
    echo "🔵 Starting Next.js frontend on port 3000..."
    cd frontend
    pnpm dev &
    FRONTEND_PID=$!
    cd ..
    echo "Frontend PID: $FRONTEND_PID"
}

# Function to start storybook
start_storybook() {
    echo "📚 Starting Storybook on port 6006..."
    cd frontend
    pnpm storybook &
    STORYBOOK_PID=$!
    cd ..
    echo "Storybook PID: $STORYBOOK_PID"
}

# Trap to kill background processes on exit
cleanup() {
    echo ""
    echo "🛑 Shutting down services..."
    if [ ! -z "${BACKEND_PID:-}" ]; then
        kill $BACKEND_PID 2>/dev/null || true
    fi
    if [ ! -z "${FRONTEND_PID:-}" ]; then
        kill $FRONTEND_PID 2>/dev/null || true
    fi
    if [ ! -z "${STORYBOOK_PID:-}" ]; then
        kill $STORYBOOK_PID 2>/dev/null || true
    fi
    exit 0
}
trap cleanup SIGINT SIGTERM

# Start services based on flags
if [ "$BACKEND_ONLY" = true ]; then
    start_backend
elif [ "$FRONTEND_ONLY" = true ]; then
    start_frontend
else
    start_backend
    start_frontend
    
    if [ "$STORYBOOK" = true ]; then
        start_storybook
    fi
fi

echo ""
echo "✅ Services started!"
echo ""
echo "📍 Service URLs:"
if [ "$FRONTEND_ONLY" = false ]; then
    echo "  🟡 Laravel Backend: $BACKEND_EXT_URL"
fi
if [ "$BACKEND_ONLY" = false ]; then
    echo "  🔵 Next.js Frontend: $FRONTEND_EXT_URL"
fi
if [ "$STORYBOOK" = true ]; then
    echo "  📚 Storybook: $STORYBOOK_EXT_URL"
fi
echo ""
echo "Press Ctrl+C to stop all services"

# Wait for background processes
wait