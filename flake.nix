{
  description = "envy-profile";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.buildEnv {
          name = "envy-profile";
          paths = with pkgs; [
            direnv
            gh
            git
            jq
            nixfmt
            starship
            yq
          ];
        };
      }
    );
}
