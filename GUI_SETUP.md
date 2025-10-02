# GUI表示セットアップガイド

このプロジェクトはOpenGLアプリケーションをGitHub Codespacesで実行できるようにセットアップされています。

## 🌐 VNC経由でGUIを表示（推奨）

GitHub CodespacesではVNC経由でGUIアプリケーションを表示します。ブラウザでもローカルVS Codeでも同じ方法で動作します。

### 実行手順

1. **アプリケーションを実行**：
   ```bash
   cd /workspace/Advanced01/src
   make run
   ```

2. **GUIを表示**：
   - VS Codeの下部にある「**ポート**」タブをクリック
   - ポート **6080** の行を探す
   - 「地球儀」アイコン（🌐）をクリックしてブラウザで開く
   - noVNC web clientが開き、GUIが表示されます！

> **ヒント**: アプリケーションを起動してからGUIを開いてください

### VNCクライアントで直接接続（オプション）

より高品質な表示を得るには、VNCクライアント（RealVNC、TigerVNC、Remminaなど）を使用できます：

1. VS Codeの「ポート」タブでポート **5901** を確認
2. VNCクライアントで `localhost:5901` に接続
3. パスワードは不要です

---

## トラブルシューティング

### エラー: "Failed to create GLFW window"

このエラーが表示される場合：

1. **DISPLAY変数を確認**：
   ```bash
   echo $DISPLAY
   # 結果が ":99" でない場合は設定
   export DISPLAY=:99
   ```

2. **ディスプレイサーバーが起動しているか確認**：
   ```bash
   ps aux | grep -E "(Xvfb|x11vnc)"
   ```

3. **手動でディスプレイをセットアップ**：
   ```bash
   bash /workspace/.devcontainer/start-display.sh
   ```

### VNCが表示されない

1. **ポートが転送されているか確認**：
   - VS Codeの「ポート」タブを確認
   - ポート5901と6080が表示されているはず

2. **VNCサーバーを再起動**：
   ```bash
   # 既存のプロセスを停止
   pkill -f "Xvfb|x11vnc|websockify"
   
   # 再起動
   bash /workspace/.devcontainer/start-display.sh
   ```

---

## 📋 技術詳細

GitHub Codespacesでは以下の技術スタックでGUIを実現しています：

- **Xvfb** (X Virtual Framebuffer): 仮想ディスプレイサーバー（ディスプレイ `:99`）
- **x11vnc**: XvfbをVNCプロトコルで共有（ポート5901）
- **websockify + noVNC**: WebブラウザからVNCにアクセス可能に（ポート6080）
- **Mesa llvmpipe**: ソフトウェアOpenGLレンダラー

これにより、物理的なGPUがなくてもOpenGLアプリケーションを実行できます。

---

## 使用されるポート

- **5901**: VNCサーバー（x11vnc）
- **6080**: noVNC Webクライアント（ブラウザアクセス用）

これらのポートはCodespacesによって自動的にローカルマシンに転送されます。
