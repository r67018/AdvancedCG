{
  description = "Advanced CG - OpenGL development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Use an older nixpkgs version that still has DevIL
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-old, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-old = nixpkgs-old.legacyPackages.${system};

        # OpenGL and graphics libraries
        buildInputs = with pkgs; [
          # OpenGL libraries
          libGL
          libGLU
          mesa
          glew
          glfw

          # DevIL image library from older nixpkgs
          pkgs-old.libdevil

          # Build tools
          gnumake
          gcc
          pkg-config

          # X11 libraries (needed for GLFW on Linux)
          xorg.libX11
          xorg.libXrandr
          xorg.libXinerama
          xorg.libXcursor
          xorg.libXi
          xorg.libXext
        ];

        # Additional packages for devcontainer
        devcontainerInputs = buildInputs ++ (with pkgs; [
          # Virtual display and VNC for GUI in Codespaces
          xorg.xorgserver  # Xvfb
          xvfb-run
          x11vnc
          python3Packages.websockify

          # noVNC for browser-based VNC access
          novnc

          # Development tools
          git
          vim
          gdb
          glxinfo
          mesa-demos

          # Shell utilities
          bash
          coreutils
        ]);

        # Library path for runtime
        libPath = pkgs.lib.makeLibraryPath buildInputs;
        devcontainerLibPath = pkgs.lib.makeLibraryPath devcontainerInputs;

      in
      {
        devShells.default = pkgs.mkShell {
          inherit buildInputs;

          shellHook = ''
            echo "🎨 Advanced CG Development Environment"
            echo "======================================"
            echo ""
            echo "OpenGL libraries loaded:"
            echo "  - OpenGL/GLU"
            echo "  - GLEW (OpenGL Extension Wrangler)"
            echo "  - GLFW (windowing)"
            echo "  - DevIL (image I/O)"
            echo ""
            echo "To build and run:"
            echo "  cd Advanced01/src"
            echo "  make run"
            echo ""

            # Set up library path
            export LD_LIBRARY_PATH="${libPath}:$LD_LIBRARY_PATH"

            # Set up include paths for compilation
            export CPATH="${pkgs.glew}/include:${pkgs.glfw}/include:${pkgs-old.libdevil}/include:$CPATH"
            export LIBRARY_PATH="${pkgs.glew}/lib:${pkgs.glfw}/lib:${pkgs-old.libdevil}/lib:${pkgs.libGL}/lib:$LIBRARY_PATH"
          '';
        };

        # Devcontainer shell with VNC/display server tools
        devShells.devcontainer = pkgs.mkShell {
          buildInputs = devcontainerInputs;

          shellHook = ''
            echo "🎨 Advanced CG Devcontainer Environment"
            echo "========================================="
            echo ""
            echo "OpenGL libraries + VNC/Display tools loaded"
            echo ""
            echo "To start VNC server:"
            echo "  .devcontainer/start-display.sh"
            echo ""
            echo "To build and run:"
            echo "  cd Advanced01/src && make run"
            echo ""

            # Set up library path
            export LD_LIBRARY_PATH="${devcontainerLibPath}:$LD_LIBRARY_PATH"

            # Set up include paths for compilation
            export CPATH="${pkgs.glew}/include:${pkgs.glfw}/include:${pkgs-old.libdevil}/include:$CPATH"
            export LIBRARY_PATH="${pkgs.glew}/lib:${pkgs.glfw}/lib:${pkgs-old.libdevil}/lib:${pkgs.libGL}/lib:$LIBRARY_PATH"

            # Set display for GUI applications
            export DISPLAY=''${DISPLAY:-:99}

            # Force Mesa software rendering (llvmpipe)
            export LIBGL_ALWAYS_SOFTWARE=1
            export GALLIUM_DRIVER=llvmpipe

            # Use GLX instead of EGL
            export __GLX_VENDOR_LIBRARY_NAME=mesa

            # Disable Wayland to force X11/GLX
            unset WAYLAND_DISPLAY
            unset XDG_SESSION_TYPE
          '';
        };
      }
    );
}
