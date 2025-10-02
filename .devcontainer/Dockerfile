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
    # 追加の便利なツール
    gdb \
    valgrind \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Xvfbの起動スクリプト
RUN echo '#!/bin/bash\n\
Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &\n\
exec "$@"' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# 作業ディレクトリの設定
WORKDIR /workspace

# エントリーポイントの設定
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
