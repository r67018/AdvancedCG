# VNC自動起動の最終構成

## 🎯 解決策：Dockerのentrypoint.shでVNCサービスを起動

### 問題点
- `postStartCommand`で起動したプロセスが、スクリプト終了時に終了してしまう
- `.bashrc`からの起動はインタラクティブシェルでのみ動作
- x11vncプロセスが親プロセスと一緒に終了する

### 採用した解決策

**Dockerfileの`ENTRYPOINT`でVNCサービスを起動**

#### メリット
✅ コンテナ起動時に確実に実行される
✅ 親プロセスから完全に独立
✅ `setsid`で新しいセッションとして起動
✅ シンプルで理解しやすい

### 実装内容

#### 1. Dockerfile (`entrypoint.sh`)
```bash
#!/bin/bash
# Start VNC services in the background
setsid Xvfb :99 -screen 0 1280x1024x24 > /tmp/xvfb.log 2>&1 &
sleep 2
setsid x11vnc -display :99 -forever -nopw -shared -rfbport 5901 > /tmp/x11vnc.log 2>&1 &
sleep 2
setsid websockify --web=/usr/share/novnc 6080 localhost:5901 > /tmp/websockify.log 2>&1 &
exec "$@"
```

- `setsid`: 新しいセッションを作成して完全に独立
- `exec "$@"`: 最後のコマンド（通常は`/bin/bash`）を実行

#### 2. devcontainer.json
- `postStartCommand`を削除（不要になった）
- `postCreateCommand`はシンプルに（DISPLAY設定とスクリプト権限のみ）

### 動作フロー

```
コンテナ起動
  ↓
ENTRYPOINT (/usr/local/bin/entrypoint.sh) 実行
  ↓
1. Xvfb起動（setsidでデーモン化）
  ↓
2. x11vnc起動（setsidでデーモン化）
  ↓
3. websockify起動（setsidでデーモン化）
  ↓
4. exec /bin/bash（メインプロセス）
  ↓
✅ VNCサービスは独立して動作継続
```

### 補助ツール

#### start-display.sh
手動でVNCを再起動したい場合に使用
```bash
bash /workspace/.devcontainer/start-display.sh
```

#### check-vnc-status.sh
VNCサービスの状態確認
```bash
bash /workspace/.devcontainer/check-vnc-status.sh
```

### テスト方法

コンテナをリビルド後：
```bash
# すぐに状態確認
bash /workspace/.devcontainer/check-vnc-status.sh
```

期待される出力：
```
✅ Xvfb is running (PID: XXX)
✅ x11vnc is running (PID: XXX)
✅ websockify is running (PID: XXX)
🎉 All VNC services are running correctly!
```

## 📋 チェックリスト

- [x] Dockerfileにentrypoint.sh追加
- [x] devcontainer.jsonからpostStartCommand削除
- [x] setsidでプロセスをデーモン化
- [x] ログファイルを/tmpに出力
- [x] 補助スクリプト（start-display.sh, check-vnc-status.sh）作成
- [x] ドキュメント更新

## 🔄 次回コンテナ起動時

**完全自動化！何もする必要なし！**

コンテナが起動すると自動的に：
1. ✅ Xvfb起動
2. ✅ x11vnc起動
3. ✅ websockify起動
4. ✅ ポート6080がブラウザで開く

すぐにプログラムを実行できます：
```bash
cd Advanced01/src
make run
```
