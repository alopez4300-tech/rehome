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

# Function to start backend
start_backend() {
    echo "🟡 Starting Laravel backend on port 8000..."
    cd backend
    php artisan serve --host=0.0.0.0 --port=8000 &
    BACKEND_PID=$!
    cd ..
    echo "Backend PID: $BACKEND_PID"
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
    echo "  🟡 Laravel Backend: http://localhost:8000"
fi
if [ "$BACKEND_ONLY" = false ]; then
    echo "  🔵 Next.js Frontend: http://localhost:3000"
fi
if [ "$STORYBOOK" = true ]; then
    echo "  📚 Storybook: http://localhost:6006"
fi
echo ""
echo "Press Ctrl+C to stop all services"

# Wait for background processes
wait