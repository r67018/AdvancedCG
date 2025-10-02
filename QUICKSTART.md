# 🚀 クイックスタートガイド

## GitHub Codespacesで実行する最も簡単な方法

### 1. GUIを表示

Codespacesを開くと自動的にVNCサーバーが起動します。

1. VS Code下部の「**ポート**」タブをクリック
2. ポート **6080** の行の🌐アイコンをクリック
3. ブラウザでnoVNC画面が開きます

### 2. プログラムを実行

```bash
cd Advanced01/src
make run
```

ブラウザのnoVNC画面にGUIが表示されます！

## トラブルシューティング

### GUIが表示されない・接続できない場合

VNCサーバーを再起動してください：

```bash
# VNCサーバーを再起動
bash /workspace/.devcontainer/start-display.sh

# ポート6080をブラウザで開く
```

### "Failed to create GLFW window" エラーが出る場合

DISPLAY変数が設定されていない可能性があります：

```bash
# DISPLAY変数を設定（新しいターミナルの場合）
export DISPLAY=:99

# または、シェルを再起動
bash
```

### VNCサーバーが起動しているか確認

```bash
# VNCサービスの状態を確認
bash /workspace/.devcontainer/check-vnc-status.sh

# または、サービスを確実に起動
bash /workspace/.devcontainer/ensure-display.sh
```

---

詳細は [GUI_SETUP.md](./GUI_SETUP.md) を参照してください。
