#!/bin/bash
# ローカルVS Codeから接続している場合のX11転送設定スクリプト

echo "=== ローカルVS Code用X11設定 ==="

# ホストのDISPLAY情報を取得
HOST_DISPLAY="${DISPLAY_HOST:-:0}"

echo "ホストマシンのディスプレイに接続します..."
echo "ホストのDISPLAY: $HOST_DISPLAY"

# DISPLAY環境変数を設定
export DISPLAY="host.docker.internal$HOST_DISPLAY"

# または、直接ホストのIPを使用する場合
# export DISPLAY="$(ip route | grep default | awk '{print $3}')$HOST_DISPLAY"

echo "DISPLAY=$DISPLAY に設定しました"
echo ""
echo "ウィンドウがホストマシンに表示されるようになります。"
echo ""
echo "もし表示されない場合は、ホストマシンで以下を実行してください："
echo "  xhost +local:"
echo ""
echo "または、特定のIPからの接続を許可："
echo "  xhost +local:docker"
