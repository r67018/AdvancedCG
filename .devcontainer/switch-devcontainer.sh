#!/usr/bin/env bash
# Devcontainer設定を切り替えるスクリプト

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

show_usage() {
    cat << EOF
Devcontainer設定切り替えスクリプト

使い方:
  ./switch-devcontainer.sh <設定>

設定:
  nix    - Nixベースの設定に切り替え
  apt    - Ubuntu/aptベースの設定に切り替え
  status - 現在の設定を表示

EOF
}

show_status() {
    if [ -f "devcontainer.json" ]; then
        NAME=$(grep '"name"' devcontainer.json | head -1 | sed 's/.*"name": *"\([^"]*\)".*/\1/')
        if [[ "$NAME" == *"Nix"* ]]; then
            echo "現在の設定: Nixベース"
            echo "  ファイル: devcontainer.json (Nix版)"
        else
            echo "現在の設定: Ubuntu/aptベース"
            echo "  ファイル: devcontainer.json (apt版)"
        fi
    else
        echo "エラー: devcontainer.jsonが見つかりません"
        exit 1
    fi
}

backup_current() {
    if [ -f "devcontainer.json" ]; then
        NAME=$(grep '"name"' devcontainer.json | head -1 | sed 's/.*"name": *"\([^"]*\)".*/\1/')
        if [[ "$NAME" == *"Nix"* ]]; then
            cp devcontainer.json devcontainer.nix.json
            echo "✓ 現在のNix設定をdevcontainer.nix.jsonに保存"
        else
            cp devcontainer.json devcontainer.apt.json
            echo "✓ 現在のapt設定をdevcontainer.apt.jsonに保存"
        fi
    fi
}

switch_to_nix() {
    echo "Nixベースの設定に切り替え中..."

    backup_current

    if [ ! -f "devcontainer.nix.json" ]; then
        echo "エラー: devcontainer.nix.jsonが見つかりません"
        exit 1
    fi

    cp devcontainer.nix.json devcontainer.json
    echo "✓ devcontainer.jsonをNix版に更新"
    echo ""
    echo "🎉 Nixベースの設定に切り替えました！"
    echo ""
    echo "次のステップ:"
    echo "  1. VS CodeでCommand Paletteを開く (Ctrl+Shift+P)"
    echo "  2. 'Codespaces: Rebuild Container' を実行"
    echo "  3. コンテナが再ビルドされるのを待つ"
}

switch_to_apt() {
    echo "Ubuntu/aptベースの設定に切り替え中..."

    backup_current

    if [ ! -f "devcontainer.apt.json" ]; then
        echo "エラー: devcontainer.apt.jsonが見つかりません"
        exit 1
    fi

    cp devcontainer.apt.json devcontainer.json
    echo "✓ devcontainer.jsonをapt版に更新"
    echo ""
    echo "🎉 Ubuntu/aptベースの設定に切り替えました！"
    echo ""
    echo "次のステップ:"
    echo "  1. VS CodeでCommand Paletteを開く (Ctrl+Shift+P)"
    echo "  2. 'Codespaces: Rebuild Container' を実行"
    echo "  3. コンテナが再ビルドされるのを待つ"
}

# メイン処理
if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

case "$1" in
    nix)
        switch_to_nix
        ;;
    apt)
        switch_to_apt
        ;;
    status)
        show_status
        ;;
    *)
        echo "エラー: 無効なオプション '$1'"
        show_usage
        exit 1
        ;;
esac
