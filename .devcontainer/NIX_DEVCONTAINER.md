# Nix版 Devcontainer セットアップガイド

このディレクトリには2つのdevcontainer設定があります：

## 設定ファイル

1. **`devcontainer.json`** - 既存のDockerfile（Ubuntu + apt）ベース
2. **`devcontainer.nix.json`** - 新しいNixベース（推奨）

## Nix版に切り替える方法

### ステップ1: ファイル名を変更

```bash
cd .devcontainer

# 既存の設定をバックアップ
mv devcontainer.json devcontainer.apt.json

# Nix版を有効化
mv devcontainer.nix.json devcontainer.json
```

### ステップ2: Codespacesをリビルド

1. VS CodeでCommand Palette（Ctrl+Shift+P または Cmd+Shift+P）を開く
2. "Codespaces: Rebuild Container" を選択
3. コンテナが再ビルドされるのを待つ

## Nix版の利点

### 🎯 再現性
- Nixの宣言的設定により、誰がどこで実行しても同じ環境
- バージョンの衝突がない

### 🔒 信頼性
- `flake.lock`でパッケージバージョンを固定
- タイムスタンプベースの依存関係管理

### 🚀 効率性
- パッケージの共有とキャッシング
- 必要なものだけインストール

### 🧩 モジュール性
- 開発環境とdevcontainer環境を分離可能
- 各プロジェクトで設定を簡単にカスタマイズ

## 使い方

### コンテナ内での開発

Nix版devcontainerでは、すべてのコマンドは`nix develop`環境内で実行されます：

```bash
# 開発環境に入る
nix develop /workspace#devcontainer

# または直接コマンド実行
nix develop /workspace#devcontainer --command make run
```

### ビルドと実行

```bash
cd Advanced01/src
nix develop /workspace#devcontainer --command make run
```

## VNCサーバー

VNCサーバーは自動的に起動します：
- **ポート 5901**: VNCダイレクト接続
- **ポート 6080**: noVNC（ブラウザベースVNC）

ブラウザでポート6080を開いてGUIアプリケーションを表示できます。

## トラブルシューティング

### Nixコマンドが見つからない

コンテナ内で：
```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### 環境が古い

```bash
nix flake update
```

### VNCが起動しない

ログを確認：
```bash
cat /tmp/vnc-startup.log
cat /tmp/xvfb.log
cat /tmp/x11vnc.log
```

## 元の設定に戻す

Nix版で問題が発生した場合：

```bash
cd .devcontainer
mv devcontainer.json devcontainer.nix.json
mv devcontainer.apt.json devcontainer.json
```

その後、Codespacesをリビルドしてください。

## 技術詳細

### 使用しているNixパッケージ

- **OpenGL**: libGL, libGLU, glew, glfw
- **DevIL**: libdevil（nixpkgs 23.05から）
- **ビルドツール**: gcc, make, pkg-config
- **VNC**: Xvfb, x11vnc, websockify, noVNC
- **開発ツール**: git, vim, gdb

### flake.nix構造

```nix
{
  devShells = {
    default = ...;        # ローカル開発用
    devcontainer = ...;   # Codespaces用（VNCツール含む）
  };
}
```

## 参考資料

- [Nix公式ドキュメント](https://nixos.org/manual/nix/stable/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [プロジェクトのNIX_SETUP.md](../NIX_SETUP.md)
