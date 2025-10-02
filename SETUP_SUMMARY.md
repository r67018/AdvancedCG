# 設定変更の要約

## 実施した変更

GitHub CodespacesでVNC経由でGUIウィンドウをブラウザに表示できるように設定しました。
**コンテナ起動時に自動的にVNCサーバーが起動します。**

### 1. devcontainer.json の変更
- **VNCポート転送**: ポート5901（VNC）と6080（noVNC Web）を転送
- **postCreateCommand**: .bashrcにDISPLAY=:99を設定、スクリプトの実行権限付与
- **postStartCommand**: ディスプレイセットアップスクリプトを自動実行
- **portsAttributes**: ポート6080を自動的にブラウザで開くように設定

### 2. Dockerfile の更新
- **x11vnc**: VNCサーバーを追加（ブラウザ版用）
- **websockify**: Webブラウザからのアクセスを可能にするツール
- **noVNC**: ブラウザベースのVNCクライアント

### 3. 起動スクリプト (start-display.sh)
Xvfb + x11vnc + websockify を自動起動：
- **Xvfb**: 仮想ディスプレイサーバー（:99）- nohupでデーモン化
- **x11vnc**: VNCサーバー（ポート5901）- バックグラウンドモードで起動
- **websockify**: noVNC Webクライアント（ポート6080）- 安定動作
- **ログファイル**: /tmp/{xvfb,x11vnc,websockify}.log でトラブルシューティング可能

### 4. ヘルパースクリプト (ensure-display.sh)
サービスの状態確認と必要に応じて再起動

## 利用方法（完全自動化済み）

### コンテナ起動後

**何もする必要ありません！**

コンテナが起動すると、Dockerの`ENTRYPOINT`が自動的にVNCサービスを起動します：

1. ✅ **Xvfb** - 仮想ディスプレイサーバー
2. ✅ **x11vnc** - VNCサーバー
3. ✅ **websockify** - noVNC Webクライアント

### プログラムを実行

1. **VS Code下部の「ポート」タブでポート6080を開く**
2. **プログラムを実行**:

```bash
cd Advanced01/src
make run
```

→ **ブラウザでnoVNC経由でGUIが表示されます！**

### VNCサービスの状態確認

```bash
# 状態確認
bash /workspace/.devcontainer/check-vnc-status.sh

# 手動で再起動したい場合
bash /workspace/.devcontainer/start-display.sh
```

### DISPLAY変数について

`.bashrc`に自動設定されているため、新しいターミナルでも自動的に設定されます。

## 技術的な詳細

### 自動起動の仕組み

VNCサービスは**Dockerの`ENTRYPOINT`スクリプト**で起動されます：

```
コンテナ起動 → entrypoint.sh実行 → VNCサービス起動（setsidでデーモン化） → bashシェル起動
```

- `setsid`で新しいセッションを作成し、親プロセスから完全に独立
- ログは`/tmp/{xvfb,x11vnc,websockify}.log`に出力
- シェルが終了してもVNCサービスは継続

詳細は [`VNC_AUTO_START_SOLUTION.md`](./.devcontainer/VNC_AUTO_START_SOLUTION.md) を参照してください。

## 次回以降のCodespaces起動時

**完全自動！何もする必要ありません！**

コンテナを起動するだけで、すぐに開発を開始できます。

### コンテナをリビルドする場合

1. コマンドパレット (Ctrl+Shift+P / Cmd+Shift+P)
2. "Dev Containers: Rebuild Container" を選択

または、新しいCodespacesを作成してください。

## トラブルシューティング

詳細は [GUI_SETUP.md](./GUI_SETUP.md) を参照してください。
