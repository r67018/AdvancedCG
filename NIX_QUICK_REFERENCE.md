# 🎨 Advanced CG - Nix環境セットアップ完了！

## ✅ セットアップ内容

このプロジェクトに以下のNix環境が追加されました：

### 1. ローカル開発環境（Nix）
- `flake.nix`: Nix環境定義
- `flake.lock`: パッケージバージョン固定
- `NIX_SETUP.md`: ローカル環境の使い方

### 2. GitHub Codespaces対応（Nix版）
- `.devcontainer/Dockerfile.nix`: NixベースDockerfile
- `.devcontainer/devcontainer.nix.json`: Nix版devcontainer設定
- `.devcontainer/start-display-nix.sh`: VNCサーバー起動スクリプト
- `.devcontainer/switch-devcontainer.sh`: 設定切り替えスクリプト
- `CODESPACES_NIX.md`: Codespaces Nix版ガイド

### 3. 便利なツール
- `run.sh`: ビルド・実行スクリプト（ローカル用）

## 🚀 クイックスタート

### ローカル開発（Nix使用）

```bash
# リポジトリルートで
nix develop

# ビルド・実行
cd Advanced01/src
make run
```

または便利スクリプトを使用：

```bash
# リポジトリルートで
./run.sh 01        # Advanced01をビルド・実行
./run.sh 02 build  # Advanced02をビルドのみ
./run.sh 03 clean  # Advanced03をクリーン
```

### GitHub Codespaces（Nix版に切り替え）

```bash
# Codespaces内で
cd .devcontainer
./switch-devcontainer.sh nix

# その後、VS CodeでCodespacesをリビルド
# Command Palette > "Codespaces: Rebuild Container"
```

## 📚 ドキュメント

| ドキュメント | 内容 |
|-------------|------|
| [NIX_SETUP.md](NIX_SETUP.md) | ローカルでのNix環境の使い方 |
| [CODESPACES_NIX.md](CODESPACES_NIX.md) | GitHub Codespaces Nix版ガイド |
| [.devcontainer/NIX_DEVCONTAINER.md](.devcontainer/NIX_DEVCONTAINER.md) | Devcontainer技術詳細 |
| [README.md](README.md) | メインドキュメント |
| [QUICKSTART.md](QUICKSTART.md) | Codespacesクイックスタート |

## 🎯 使い分けガイド

### ローカル開発

| 環境 | 推奨度 | コメント |
|------|--------|----------|
| **Nix** | ⭐⭐⭐⭐⭐ | 再現性が高く、どのOSでも同じ環境 |
| Ubuntu (apt) | ⭐⭐⭐⭐ | 従来通りの方法 |
| Mac (Homebrew) | ⭐⭐⭐ | Macユーザーには手軽 |
| Windows (VS) | ⭐⭐⭐ | Windowsネイティブ開発 |

### GitHub Codespaces

| 環境 | 推奨度 | コメント |
|------|--------|----------|
| **Nix版** | ⭐⭐⭐⭐⭐ | 再現性・キャッシング効率◎ |
| apt版 | ⭐⭐⭐⭐ | 従来通り、すぐ使える |

## 🔄 環境の切り替え

### Codespacesの設定を切り替え

```bash
# ステータス確認
cd .devcontainer
./switch-devcontainer.sh status

# Nix版に切り替え
./switch-devcontainer.sh nix

# apt版に戻す
./switch-devcontainer.sh apt
```

## ✨ Nixの利点

1. **完全な再現性**: `flake.lock`でバージョン固定
2. **クリーンな環境**: パッケージ衝突なし
3. **クロスプラットフォーム**: Linux/Mac/WSLで同じ環境
4. **宣言的**: コードとして管理できる環境
5. **ロールバック可能**: 問題があれば簡単に戻せる

## 🛠️ トラブルシューティング

### Nixコマンドが見つからない

```bash
# Nixがインストールされているか確認
which nix

# なければインストール
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### ビルドエラー

```bash
# クリーンビルド
cd Advanced01/src
make clean
nix develop --command make run
```

### 依存関係の更新

```bash
nix flake update
```

## 📝 次のステップ

1. **ローカル開発**: [NIX_SETUP.md](NIX_SETUP.md) を読む
2. **Codespaces**: [CODESPACES_NIX.md](CODESPACES_NIX.md) を読む
3. **課題を開始**: `cd Advanced01/src && make run`

## 🆘 ヘルプ

質問や問題がある場合：
1. 各ドキュメントのトラブルシューティングセクションを確認
2. Nixコミュニティ: https://nixos.org/community
3. プロジェクトのissuesを確認

---

**Happy Coding! 🎨**
