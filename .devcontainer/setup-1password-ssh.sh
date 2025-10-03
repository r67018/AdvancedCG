#!/bin/bash
# 1Password SSH Agent設定スクリプト（Linux対応版）

echo "Setting up 1Password SSH Agent integration for Linux..."

# SSH_AUTH_SOCKの設定（Linux 1Password用）
if [ -S /ssh-agent ]; then
    export SSH_AUTH_SOCK=/ssh-agent
    echo "export SSH_AUTH_SOCK=/ssh-agent" >> ~/.bashrc
    echo "✓ SSH Agent socket found and configured (Linux 1Password)"
else
    echo "⚠ SSH Agent socket not found at /ssh-agent"
    echo "  Expected: ~/.1password/agent.sock on host"
    echo "  Make sure 1Password SSH Agent is running on the host."
fi

# SSH設定ディレクトリの作成
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# SSH設定ファイルの作成（1Password Linux用）
cat > ~/.ssh/config << 'EOF'
# 1Password SSH Agent Configuration for Linux
Host *
    IdentityAgent /ssh-agent
    AddKeysToAgent yes
EOF

chmod 600 ~/.ssh/config

# SSH鍵のテスト
echo "Testing SSH Agent connection..."
echo "Debug information:"
echo "- Container SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
echo "- Socket file exists: $(test -S /ssh-agent && echo 'Yes' || echo 'No')"
echo "- Socket permissions: $(ls -la /ssh-agent 2>/dev/null || echo 'N/A')"

if ssh-add -l >/dev/null 2>&1; then
    echo "✓ SSH Agent is working and has keys:"
    ssh-add -l
else
    echo "⚠ SSH Agent test failed. Please check:"
    echo "  1. 1Password app is running on the Linux host"
    echo "  2. SSH Agent is enabled in 1Password settings"
    echo "  3. Host ~/.1password/agent.sock exists and is accessible"
    echo "  4. Dev Container has been rebuilt after configuration changes"
    echo ""
    echo "Host-side troubleshooting commands:"
    echo "  ls -la ~/.1password/agent.sock"
    echo "  ssh-add -l"
    echo "  systemctl --user status com.1password.SSH-Agent"
fi

echo "1Password SSH Agent setup complete!"
