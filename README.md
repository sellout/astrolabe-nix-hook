# Astrolabe Nix hook

[![built with garnix](https://img.shields.io/endpoint?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fsellout%2Fastrolabe-nix-hook)](https://garnix.io/repo/sellout/astrolabe-nix-hook)
[![Nix CI](https://nix-ci.com/badge/gh:sellout:astrolabe-nix-hook)](https://nix-ci.com/gh:sellout:astrolabe-nix-hook)
[![Project Manager](https://img.shields.io/badge/%20-Project%20Manager-%235277C3?logo=nixos&labelColor=%23cccccc)](https://sellout.github.io/project-manager/)

This repo has no effect when used as a Nix flake input.

However, [Astrolabe]() will locally override that input to create a “constellation” from a set of inter-dependent repositories. Making poly-repo development feel like monorepo development.

Astrolabe can operate without needing this hook if you’ve configured overrides, etc. to use flake inputs directly. However, if you are overriding, say, some Haskell packages by pulling other versions from Hackage, you might do

``` nix
{
  outputs = _: {
    overlays.default = final: prev: {
      haskellPackages = prev.haskellPackages.override (old: {
        some-package = lib.haskell.callHackageDirect { … };
      });
    }
  };
}
```

then this flake allows you to make that overlay locally-overridable:

``` nix
{
  inputs.astrolabe-hook.url = "github:sellout/astrolabe-nix-hook";

  outputs = {astrolabe-hook, nixpkgs, ...}: {
    overlays.default = final: prev: nixpkgs.lib.composeManyExtensions [
      {
        haskellPackages = prev.haskellPackages.override (old: {
          some-package = lib.haskell.callHackageDirect { … };
        });
      }
      astrolabe-hook.overlays.default
    ]
      final prev;
  };
}
```

If you don’t define your own overlays, you can also apply this to Nixpkgs directly

``` nix
{
  inputs.astrolabe-hook.url = "github:sellout/astrolabe-nix-hook";

  outputs = {astrolabe-hook, nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs =
      nixpkgs.legacyPackages.${system}.appendOverlays
      [astrolabe-hook.overlays.default];
  in …;
}
```
