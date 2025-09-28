#!/bin/bash

# 🚀 One-Line Filament Admin Setup
# Usage: curl -sSL https://raw.githubusercontent.com/your-repo/rehome/main/scripts/quick-setup.sh | bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Starting Filament Admin Quick Setup...${NC}"

# Check if we're in the right directory
if [[ ! -f "backend/artisan" ]]; then
    if [[ -f "artisan" ]]; then
        echo -e "${GREEN}✅ Found Laravel in current directory${NC}"
    else
        echo "❌ Laravel project not found. Please run from project root or backend directory."
        exit 1
    fi
else
    echo -e "${GREEN}✅ Found Laravel in backend directory${NC}"
    cd backend
fi

# Run the full setup script
if [[ -f "../scripts/setup-admin-panel.sh" ]]; then
    echo -e "${BLUE}📋 Running full setup script...${NC}"
    bash ../scripts/setup-admin-panel.sh
else
    echo -e "${BLUE}📋 Downloading and running setup script...${NC}"
    # In a real deployment, this would download from your repository
    echo "Setup script not found locally. Please run from the rehome project directory."
    exit 1
fi

echo -e "${GREEN}🎉 Quick setup complete!${NC}"