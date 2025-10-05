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

        # Library path for runtime
        libPath = pkgs.lib.makeLibraryPath buildInputs;

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
      }
    );
}
