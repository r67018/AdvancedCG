#!/bin/bash
# VNCサービスの状態確認スクリプト

echo "==================================="
echo "  VNC Services Status Check"
echo "==================================="
echo ""

# Xvfbの確認
if pgrep -x "Xvfb" > /dev/null; then
    XVFB_PID=$(pgrep -x "Xvfb")
    echo "✅ Xvfb is running (PID: $XVFB_PID)"
else
    echo "❌ Xvfb is NOT running"
fi

# x11vncの確認
if pgrep -x "x11vnc" > /dev/null; then
    X11VNC_PID=$(pgrep -x "x11vnc")
    echo "✅ x11vnc is running (PID: $X11VNC_PID)"
else
    echo "❌ x11vnc is NOT running"
fi

# websockifyの確認
if pgrep -f "websockify.*6080" > /dev/null; then
    WEBSOCKIFY_PID=$(pgrep -f "websockify.*6080" | head -1)
    echo "✅ websockify is running (PID: $WEBSOCKIFY_PID)"
else
    echo "❌ websockify is NOT running"
fi

echo ""
echo "==================================="
echo "  Environment Variables"
echo "==================================="
echo "DISPLAY: $DISPLAY"

echo ""
echo "==================================="
echo "  Log Files"
echo "==================================="
echo "Xvfb log: /tmp/xvfb.log"
echo "x11vnc log: /tmp/x11vnc.log"
echo "websockify log: /tmp/websockify.log"

echo ""
if pgrep -x "Xvfb" > /dev/null && pgrep -x "x11vnc" > /dev/null && pgrep -f "websockify.*6080" > /dev/null; then
    echo "🎉 All VNC services are running correctly!"
    echo "   Open port 6080 in your browser to access the GUI"
else
    echo "⚠️  Some services are not running."
    echo "   Run: bash /workspace/.devcontainer/start-display.sh"
fi
