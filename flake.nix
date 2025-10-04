# scp -q /home/nick/Documents/VScodium/CoopNetConf/flake.nix nick@10.25.25.7:/home/nick
{
  description = "HomeLab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./modules/traefik.nix
        ];
      };
    };
}
