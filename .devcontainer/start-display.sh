#!/bin/bash
# Display setup script for GitHub Codespaces

echo "=== Display Setup for GitHub Codespaces ==="

# Set DISPLAY environment variable
export DISPLAY=:99

# Kill any existing processes
echo "Stopping any existing display services..."
pkill -9 Xvfb 2>/dev/null || true
pkill -9 x11vnc 2>/dev/null || true
pkill -9 websockify 2>/dev/null || true
sleep 1

# Always start Xvfb for browser-based access
echo "Starting Xvfb on :99..."

# Start Xvfb with setsid to detach from terminal session
setsid Xvfb :99 -screen 0 1280x1024x24 > /tmp/xvfb.log 2>&1 &
XVFB_PID=$!
sleep 3

# Check if Xvfb started successfully
if ! ps -p $XVFB_PID > /dev/null 2>&1; then
    echo "❌ Failed to start Xvfb"
    cat /tmp/xvfb.log 2>/dev/null
    exit 1
fi

echo "✅ Xvfb started on :99 (PID: $XVFB_PID)"

# Start x11vnc with setsid to fully detach from parent
echo "Starting x11vnc..."
setsid x11vnc -display :99 -forever -nopw -shared -rfbport 5901 > /tmp/x11vnc.log 2>&1 &
X11VNC_PID=$!
disown $X11VNC_PID 2>/dev/null || true
sleep 4

# Check if x11vnc is running
if ! pgrep -x "x11vnc" > /dev/null; then
    echo "❌ Failed to start x11vnc"
    echo "Last 20 lines of x11vnc log:"
    tail -20 /tmp/x11vnc.log 2>/dev/null
    exit 1
fi

X11VNC_ACTUAL_PID=$(pgrep -x "x11vnc")
echo "✅ x11vnc started on port 5901 (PID: $X11VNC_ACTUAL_PID)"

# Start websockify for noVNC with setsid
echo "Starting websockify for noVNC..."
if command -v websockify &> /dev/null; then
    setsid websockify --web=/usr/share/novnc 6080 localhost:5901 > /tmp/websockify.log 2>&1 &
    WEBSOCKIFY_PID=$!
    disown $WEBSOCKIFY_PID 2>/dev/null || true
    sleep 3
    
    if pgrep -f "websockify.*6080" > /dev/null; then
        WEBSOCKIFY_ACTUAL_PID=$(pgrep -f "websockify.*6080" | head -1)
        echo "✅ noVNC web client started on port 6080"
        echo ""
        echo "🎉 All services started successfully!"
        echo "   📱 Open port 6080 in your browser to access the GUI"
        echo ""
        echo "Services running:"
        echo "  - Xvfb (PID: $(pgrep -x Xvfb))"
        echo "  - x11vnc (PID: $X11VNC_ACTUAL_PID)"
        echo "  - websockify (PID: $WEBSOCKIFY_ACTUAL_PID)"
    else
        echo "❌ Failed to start websockify"
        cat /tmp/websockify.log 2>/dev/null
    fi
else
    echo "⚠️  websockify not found, noVNC web client will not be available"
fi

echo ""
echo "Display setup complete!"
echo "DISPLAY is set to: $DISPLAY"
