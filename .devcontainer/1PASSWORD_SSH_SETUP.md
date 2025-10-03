# 1Password SSH Agent 設定ガイド

## 概要
このdevcontainerは1PasswordのSSH Agentを使用してホスト側のSSH鍵にアクセスできるように設定されています。

## 前提条件

### ホスト側（Linux）
1. **1Passwordアプリがインストールされている**
2. **1PasswordでSSH Agentが有効になっている**
   - 1Passwordアプリを開く
   - 設定 > Developer > "Use the SSH agent" を有効にする
3. **SSH鍵が1Passwordに保存されている**
4. **ホスト側でSSH_AUTH_SOCKが設定されている**
   ```bash
   # ~/.bashrc または ~/.zshrc に追加
   export SSH_AUTH_SOCK=~/.1password/agent.sock
   ```

### 設定確認方法

#### Linux ホスト
```bash
# 1Password SSH Agentソケットが存在するか確認
ls -la ~/.1password/agent.sock

# SSH_AUTH_SOCKが設定されているか確認
echo $SSH_AUTH_SOCK

# SSH Agentが動作しているか確認
ssh-add -l

# 1Password SSH Agentサービスの状態確認
systemctl --user status com.1password.SSH-Agent
```

#### ホスト側での問題診断
プロジェクト内の診断スクリプトを使用：
```bash
# ホスト側で実行（devcontainer外で）
./workspace/.devcontainer/check-host-ssh-agent.sh
```

#### Windows
```powershell
# SSH_AUTH_SOCKが設定されているか確認
$env:SSH_AUTH_SOCK
# 通常は以下のようなパスが表示される
# \\.\pipe\openssh-ssh-agent

# SSH Agentが動作しているか確認
ssh-add -l
```

## Dev Container での使用方法

### 1. コンテナの再構築
設定変更後は必ずコンテナを再構築してください：
```
Ctrl+Shift+P → "Dev Containers: Rebuild Container"
```

### 2. SSH接続のテスト
コンテナ内で以下のコマンドを実行：
```bash
# SSH Agentの状態確認
ssh-add -l

# GitHubへの接続テスト（GitHub鍵がある場合）
ssh -T git@github.com
```

### 3. Git設定
SSH鍵を使用してGitリポジトリにアクセスする場合：
```bash
# SSHでクローン
git clone git@github.com:username/repository.git

# HTTPSからSSHに変更
git remote set-url origin git@github.com:username/repository.git
```

## トラブルシューティング

### SSH Agentが見つからない場合
```bash
# 手動でSSH設定スクリプトを実行
/workspace/.devcontainer/setup-1password-ssh.sh
```

### エラー: "Could not open a connection to your authentication agent"
1. **ホスト側の確認**：
   ```bash
   # ホスト側で実行
   ls -la ~/.1password/agent.sock  # ソケットファイルの存在確認
   ssh-add -l                      # SSH Agent動作確認
   ```

2. **環境変数の設定**：
   ```bash
   # ホスト側の ~/.bashrc に追加
   export SSH_AUTH_SOCK=~/.1password/agent.sock
   ```

3. **1Password設定の確認**：
   - 1Passwordアプリ > 設定 > Developer > "Use the SSH agent" が有効
   - 1Passwordアプリが起動している

4. **Dev Containerの再構築**

### エラー: "ssh-agent socket not found"
1. ホスト側で診断スクリプトを実行：
   ```bash
   ./workspace/.devcontainer/check-host-ssh-agent.sh
   ```
2. 1Passwordアプリの再起動
3. ターミナルの再起動（環境変数の反映）

### Windows固有の問題
Windowsでは以下の追加設定が必要な場合があります：
1. OpenSSH Authentication Agentサービスが無効になっていることを確認
2. 1PasswordのSSH Agentが有効になっていることを確認

## セキュリティノート
- SSH鍵はホスト側に保存され、コンテナ内にコピーされません
- SSH Agentフォワーディングによってセキュアにアクセスします
- コンテナが削除されても鍵は安全です

## 参考リンク
- [1Password SSH Agent documentation](https://developer.1password.com/docs/ssh/)
- [Dev Containers SSH documentation](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials)
