#!/usr/bin/env bash

# Advanced CG - Nix環境でビルド・実行するスクリプト

set -e

# 使い方を表示
show_usage() {
    cat << EOF
Advanced CG ビルド・実行スクリプト

使い方:
  ./run.sh <課題番号> [コマンド]

課題番号:
  01, 02, 03, 04  - Advanced01 ～ Advanced04

コマンド:
  run (デフォルト)  - ビルドして実行
  build            - ビルドのみ
  clean            - ビルド成果物を削除
  rebuild          - クリーンビルドして実行

例:
  ./run.sh 01          # Advanced01をビルド・実行
  ./run.sh 02 build    # Advanced02をビルドのみ
  ./run.sh 03 clean    # Advanced03をクリーン
  ./run.sh 04 rebuild  # Advanced04をクリーンビルド・実行

EOF
}

# 引数チェック
if [ $# -lt 1 ]; then
    show_usage
    exit 1
fi

ASSIGNMENT=$1
COMMAND=${2:-run}

# 課題ディレクトリを設定
case $ASSIGNMENT in
    01)
        DIR="Advanced01"
        ;;
    02)
        DIR="Advanced02"
        ;;
    03)
        DIR="Advanced03"
        ;;
    04)
        DIR="Advanced04"
        ;;
    *)
        echo "エラー: 無効な課題番号 '$ASSIGNMENT'"
        echo "01, 02, 03, 04 のいずれかを指定してください"
        exit 1
        ;;
esac

# ディレクトリ存在チェック
if [ ! -d "$DIR/src" ]; then
    echo "エラー: $DIR/src が見つかりません"
    exit 1
fi

echo "📚 $DIR を処理中..."
cd "$DIR/src"

# コマンド実行
case $COMMAND in
    run)
        echo "🔨 ビルド・実行中..."
        nix develop --command make run
        ;;
    build)
        echo "🔨 ビルド中..."
        nix develop --command make
        ;;
    clean)
        echo "🧹 クリーン中..."
        nix develop --command make clean
        ;;
    rebuild)
        echo "🧹 クリーン中..."
        nix develop --command make clean
        echo "🔨 ビルド・実行中..."
        nix develop --command make run
        ;;
    *)
        echo "エラー: 無効なコマンド '$COMMAND'"
        echo "run, build, clean, rebuild のいずれかを指定してください"
        exit 1
        ;;
esac
