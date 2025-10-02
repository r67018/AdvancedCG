FROM ubuntu:22.04

# 環境変数の設定（対話式インストールを回避）
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99

# 基本的なパッケージとOpenGL開発環境のインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    wget \
    curl \
    # OpenGL関連
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    mesa-utils \
    # GLEW（OpenGL Extension Wrangler）
    libglew-dev \
    # GLFW3（ウィンドウ管理）
    libglfw3-dev \
    # GLM（数学ライブラリ）
    libglm-dev \
    # DevIL（画像読み込みライブラリ）
    libdevil-dev \
    # X11関連（GUIアプリケーション用）
    xorg-dev \
    libx11-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    # Xvfb（仮想ディスプレイ）
    xvfb \
    # VNC関連（リモートGUI表示用）
    x11vnc \
    python3 \
    python3-pip \
    # 追加の便利なツール
    gdb \
    valgrind \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# websockify（noVNC用）をインストール
RUN pip3 install websockify

# noVNCをインストール（オプション：Webブラウザからのアクセス用）
RUN git clone https://github.com/novnc/noVNC.git /usr/share/novnc && \
    cd /usr/share/novnc && \
    git checkout v1.4.0

# VNCサービス起動スクリプト
RUN echo '#!/bin/bash\n\
# Start VNC services in the background\n\
setsid Xvfb :99 -screen 0 1280x1024x24 > /tmp/xvfb.log 2>&1 &\n\
sleep 2\n\
setsid x11vnc -display :99 -forever -nopw -shared -rfbport 5901 > /tmp/x11vnc.log 2>&1 &\n\
sleep 2\n\
setsid websockify --web=/usr/share/novnc 6080 localhost:5901 > /tmp/websockify.log 2>&1 &\n\
exec "$@"' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# 作業ディレクトリの設定
WORKDIR /workspace

# エントリーポイントの設定
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
