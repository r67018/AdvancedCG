#!/bin/bash
# Ensure display services are running

# Check if services are running
if ! pgrep -x "Xvfb" > /dev/null || ! pgrep -x "x11vnc" > /dev/null || ! pgrep -f "websockify.*6080" > /dev/null; then
    echo "Display services not running. Starting..."
    bash /workspace/.devcontainer/start-display.sh
else
    echo "Display services already running."
fi
