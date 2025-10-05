# GitHub Codespaces - Nix版セットアップ

## 🆕 Nixベースのdevcontainer

このプロジェクトでは、2つのdevcontainer設定を提供しています：

1. **Ubuntu/aptベース** (デフォルト) - 従来のDockerfile使用
2. **Nixベース** (推奨) - 再現性の高いNix環境

## Nix版の利点

### ✨ なぜNixを使うのか？

- **完全な再現性**: どこで実行しても同じ環境
- **バージョン管理**: flake.lockで依存関係を厳密に固定
- **クリーンな環境**: パッケージの衝突がない
- **高速なキャッシング**: Nixのバイナリキャッシュを活用
- **宣言的設定**: コードとして管理できる環境定義

## Nix版に切り替える

### 方法1: スクリプトを使用（簡単）

```bash
# .devcontainerディレクトリに移動
cd .devcontainer

# Nix版に切り替え
./switch-devcontainer.sh nix

# ステータス確認
./switch-devcontainer.sh status
```

その後、VS Codeで：
1. Command Palette（Ctrl+Shift+P / Cmd+Shift+P）を開く
2. "Codespaces: Rebuild Container"を実行

### 方法2: 手動で切り替え

```bash
cd .devcontainer

# 現在の設定をバックアップ
mv devcontainer.json devcontainer.apt.json

# Nix版を有効化
mv devcontainer.nix.json devcontainer.json
```

その後、Codespacesをリビルド。

## 使い方

### Codespacesでの開発

Nix版devcontainerでは、自動的にNix開発環境が利用可能になります：

```bash
# 開発環境シェルに入る
nix develop /workspace#devcontainer

# または、直接コマンドを実行
nix develop /workspace#devcontainer --command bash
```

### ビルドと実行

```bash
cd Advanced01/src

# 方法1: nix develop経由で実行
nix develop /workspace#devcontainer --command make run

# 方法2: シェルに入ってから実行
nix develop /workspace#devcontainer
make run
```

## VNCサーバー（GUI表示）

Nix版でも自動的にVNCサーバーが起動します：

- **ポート 6080**: noVNC（ブラウザでアクセス）← 推奨
- **ポート 5901**: VNCダイレクト接続

起動後、VS Code下部の「ポート」タブからポート6080を開いてください。

## トラブルシューティング

### Nixコマンドが見つからない

```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### 依存関係を更新

```bash
cd /workspace
nix flake update
```

### ビルドエラー

```bash
# クリーンビルド
cd Advanced01/src
nix develop /workspace#devcontainer --command make clean
nix develop /workspace#devcontainer --command make run
```

### VNCが起動しない

ログを確認：
```bash
cat /tmp/vnc-startup.log
cat /tmp/xvfb.log
cat /tmp/x11vnc.log
```

手動で再起動：
```bash
/workspace/.devcontainer/start-display-nix.sh
```

## 元の設定に戻す

問題が発生した場合は、Ubuntu/apt版に戻せます：

```bash
cd .devcontainer
./switch-devcontainer.sh apt
```

その後、Codespacesをリビルド。

## 技術詳細

### 含まれるパッケージ

Nix版devcontainerには以下が含まれます：

**OpenGL開発**:
- libGL, libGLU
- GLEW (OpenGL Extension Wrangler)
- GLFW (ウィンドウ管理)
- DevIL (画像I/O)

**ビルドツール**:
- gcc, make
- pkg-config
- git

**VNC/ディスプレイ**:
- Xvfb (仮想X11サーバー)
- x11vnc (VNCサーバー)
- websockify + noVNC (ブラウザアクセス)

**開発ツール**:
- vim, gdb

### ファイル構成

```
.devcontainer/
├── devcontainer.json           # アクティブな設定
├── devcontainer.apt.json       # Ubuntu/apt版（バックアップ）
├── devcontainer.nix.json       # Nix版（バックアップ）
├── Dockerfile                  # apt版Dockerfile
├── Dockerfile.nix              # Nix版Dockerfile
├── start-display.sh            # apt版VNC起動スクリプト
├── start-display-nix.sh        # Nix版VNC起動スクリプト
├── switch-devcontainer.sh      # 設定切り替えスクリプト
└── NIX_DEVCONTAINER.md         # 詳細ドキュメント
```

## より詳しい情報

- [.devcontainer/NIX_DEVCONTAINER.md](.devcontainer/NIX_DEVCONTAINER.md) - Nix版の詳細
- [NIX_SETUP.md](NIX_SETUP.md) - ローカルでのNixセットアップ
- [QUICKSTART.md](QUICKSTART.md) - クイックスタートガイド

## パフォーマンス比較

| 項目 | apt版 | Nix版 |
|------|-------|-------|
| 初回ビルド時間 | 〜5分 | 〜7分 |
| 再ビルド時間 | 〜3分 | 〜1分 (キャッシュ効果) |
| 再現性 | 中 | 高 |
| 環境の一貫性 | 中 | 高 |
| カスタマイズ性 | 低 | 高 |

## よくある質問

**Q: どちらを使うべきですか？**

A: 初心者はapt版、再現性を重視する場合はNix版を推奨します。

**Q: 両方の設定を保持できますか？**

A: はい！`switch-devcontainer.sh`で簡単に切り替えられます。

**Q: Nixの知識が必要ですか？**

A: 基本的な使用では不要です。`nix develop`コマンドだけ覚えれば使えます。

**Q: ローカルでもNixを使えますか？**

A: はい！[NIX_SETUP.md](NIX_SETUP.md)を参照してください。
