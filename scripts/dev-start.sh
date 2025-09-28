#!/bin/bash
# Quick development server startup script
# Run this after dev-setup.sh completes
# Usage: bash scripts/dev-start.sh [--storybook]

# Check for storybook flag
START_STORYBOOK=false
if [[ "$1" == "--storybook" ]]; then
    START_STORYBOOK=true
fi

echo "🚀 Starting Development Servers"
if [ "$START_STORYBOOK" = true ]; then
    echo "   (Including Storybook)"
fi
echo "==============================="

# Function to check if port is in use
check_port() {
    local port=$1
    if command -v lsof >/dev/null 2>&1; then
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            echo "⚠️  Port $port is already in use"
            return 1
        fi
    fi
    return 0
}

# Start backend in background
echo "Starting Laravel backend..."
if check_port 8000; then
    cd backend
    composer run dev &
    BACKEND_PID=$!
    echo "✅ Backend started (PID: $BACKEND_PID) - http://localhost:8000"
    cd ..
else
    echo "Skipping backend startup"
fi

# Wait a moment for backend to start
sleep 2

# Start frontend in background
echo "Starting Next.js frontend..."
if check_port 3000; then
    cd frontend
    pnpm dev &
    FRONTEND_PID=$!
    echo "✅ Frontend started (PID: $FRONTEND_PID) - http://localhost:3000"
    cd ..
else
    echo "Skipping frontend startup"
fi

# Start Storybook if requested
if [ "$START_STORYBOOK" = true ]; then
    echo "Starting Storybook..."
    if check_port 6006; then
        cd frontend
        pnpm storybook &
        STORYBOOK_PID=$!
        echo "✅ Storybook started (PID: $STORYBOOK_PID) - http://localhost:6006"
        cd ..
    else
        echo "Skipping Storybook startup (port 6006 in use)"
    fi
fi

echo ""
echo "🎉 Development servers are starting up!"
echo "======================================="
echo ""
echo "📱 Access your application:"
echo "  • Frontend: http://localhost:3000"
echo "  • Backend API: http://localhost:8000"  
echo "  • Admin Panel: http://localhost:8000/admin"
if [ "$START_STORYBOOK" = true ]; then
    echo "  • Storybook: http://localhost:6006"
fi
echo ""
echo "🛑 To stop servers:"
echo "  Press Ctrl+C or run: killall php node"
echo ""
echo "📊 To view logs, check the terminal output above"

# Keep script running to show output
wait