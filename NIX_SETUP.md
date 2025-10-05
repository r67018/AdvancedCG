# Nix環境でのビルドと実行

このプロジェクトはNixを使ってOpenGLアプリケーションをビルド・実行できるように設定されています。

## 必要なもの

- Nix パッケージマネージャ（flakes有効）
- X11ディスプレイサーバー（GUIアプリケーション実行用）

## 使い方

### 1. 開発環境に入る

リポジトリのルートディレクトリで以下を実行：

```bash
nix develop
```

これにより、以下のツールとライブラリがロードされます：
- **OpenGL/GLU** - OpenGLグラフィックスAPI
- **GLEW** - OpenGL Extension Wrangler
- **GLFW** - ウィンドウ管理・入力処理
- **DevIL** - 画像I/Oライブラリ（IL, ILU, ILUT）
- **gcc, make** - ビルドツール

### 2. ビルドと実行

開発環境に入った後、各課題のディレクトリに移動してビルド・実行できます：

```bash
cd Advanced01/src
make run
```

または、Nix環境外から直接実行する場合：

```bash
cd Advanced01/src
nix develop --command make run
```

### 3. クリーンビルド

ビルド成果物を削除する場合：

```bash
make clean
```

## 各課題のビルド方法

### Advanced01（第1回課題）
```bash
cd Advanced01/src
nix develop --command make run
```

### Advanced02（第2回課題）
```bash
cd Advanced02/src
nix develop --command make run
```

### Advanced03（第3回課題）
```bash
cd Advanced03/src
nix develop --command make run
```

### Advanced04（第4回課題）
```bash
cd Advanced04/src
nix develop --command make run
```

## トラブルシューティング

### ディスプレイエラーが出る場合

GUIアプリケーションを実行するには、X11ディスプレイサーバーが必要です。

WSL2の場合：
1. Windows側でX11サーバー（VcXsrv, X410など）を起動
2. WSL側で環境変数を設定：
   ```bash
   export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
   ```

リモートサーバーの場合：
- SSH接続時に `-X` または `-Y` オプションを使用してX11フォワーディングを有効化

### ライブラリが見つからないエラー

`nix develop`で開発環境に入っていることを確認してください。環境変数（LD_LIBRARY_PATH, CPATH, LIBRARY_PATH）が自動的に設定されます。

### ビルドエラー

1. まず `make clean` で既存のビルド成果物を削除
2. `nix flake update` で依存関係を更新
3. 再度 `nix develop --command make run` を実行

## 技術詳細

### 使用しているNixパッケージ

- **nixpkgs**: 最新の安定版（OpenGL関連ライブラリ）
- **nixpkgs-old (23.05)**: DevILライブラリ用（最新版では削除されているため）

### 環境変数

Nix開発環境では以下の環境変数が自動設定されます：

- `LD_LIBRARY_PATH`: ランタイムライブラリパス
- `CPATH`: コンパイル時のインクルードパス
- `LIBRARY_PATH`: リンク時のライブラリパス

## GitHub Codespacesでの実行

GitHub Codespacesでの実行方法については [QUICKSTART.md](./QUICKSTART.md) を参照してください。
