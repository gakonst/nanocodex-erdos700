{
  description = "Reproducible environment for the Lean proof of Erdos 700(i)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            bash
            curl
            elan
            git
            python3
            ripgrep
          ];

          shellHook = ''
            export PATH="$HOME/.elan/bin:$PATH"
          '';
        };
      });
    };
}
