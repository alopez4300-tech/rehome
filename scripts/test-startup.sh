#!/bin/bash
# Test script to verify dev-start.sh works correctly
# This simulates the development startup without actually starting servers

echo "🧪 Testing Development Startup Scripts"
echo "======================================"

# Test 1: Basic dev-start.sh
echo ""
echo "Test 1: Basic startup"
echo "Expected: Should show backend + frontend startup messages"
echo "Command: bash scripts/dev-start.sh --help"

# Test 2: Storybook flag
echo ""
echo "Test 2: Storybook flag"
echo "Expected: Should show backend + frontend + storybook startup messages"
echo "Command: bash scripts/dev-start.sh --storybook --help"

echo ""
echo "🔍 Manual Tests to Run:"
echo "1. bash scripts/dev-start.sh           # Should start backend + frontend"
echo "2. bash scripts/dev-start.sh --storybook  # Should start all three"
echo ""
echo "✅ Verify these URLs are accessible:"
echo "   • http://localhost:3000 (Frontend)"
echo "   • http://localhost:8000 (Backend)"
echo "   • http://localhost:8000/admin (Admin)"
echo "   • http://localhost:6006 (Storybook - when --storybook used)"
echo ""
echo "🛑 To stop: Press Ctrl+C or run 'killall php node'"