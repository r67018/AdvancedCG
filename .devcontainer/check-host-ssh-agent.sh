#!/bin/bash
# ホスト側で実行する1Password SSH Agent確認スクリプト

echo "=== 1Password SSH Agent Status Check ==="
echo

echo "1. Checking if 1Password SSH Agent socket exists:"
if [ -S ~/.1password/agent.sock ]; then
    echo "✓ Socket file exists: ~/.1password/agent.sock"
    ls -la ~/.1password/agent.sock
else
    echo "✗ Socket file not found: ~/.1password/agent.sock"
    echo "  Please enable SSH Agent in 1Password settings"
fi
echo

echo "2. Checking SSH_AUTH_SOCK environment variable:"
if [ -n "$SSH_AUTH_SOCK" ]; then
    echo "SSH_AUTH_SOCK = $SSH_AUTH_SOCK"
else
    echo "SSH_AUTH_SOCK is not set"
    echo "You may need to add this to your ~/.bashrc or ~/.zshrc:"
    echo "export SSH_AUTH_SOCK=~/.1password/agent.sock"
fi
echo

echo "3. Testing SSH Agent connection:"
if ssh-add -l >/dev/null 2>&1; then
    echo "✓ SSH Agent is working"
    echo "Available keys:"
    ssh-add -l
else
    echo "✗ SSH Agent connection failed"
    echo "Error details:"
    ssh-add -l
fi
echo

echo "4. Checking 1Password SSH Agent service:"
if systemctl --user is-active --quiet com.1password.SSH-Agent 2>/dev/null; then
    echo "✓ 1Password SSH Agent service is running"
    systemctl --user status com.1password.SSH-Agent --no-pager
elif pgrep -f "1password.*ssh" >/dev/null; then
    echo "✓ 1Password SSH Agent process found"
    pgrep -f -l "1password.*ssh"
else
    echo "✗ 1Password SSH Agent not running"
    echo "  Please start 1Password application and enable SSH Agent"
fi
echo

echo "5. Quick fix recommendations:"
echo "If SSH Agent is not working, try:"
echo "  1. Open 1Password app"
echo "  2. Go to Settings > Developer"
echo "  3. Enable 'Use the SSH agent'"
echo "  4. Restart your terminal/shell"
echo "  5. Add to ~/.bashrc: export SSH_AUTH_SOCK=~/.1password/agent.sock"
echo

echo "=== End of Status Check ==="
