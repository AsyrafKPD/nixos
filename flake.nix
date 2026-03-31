{
  description = "My NixOS Setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    msnap = {
      url = "github:atheeq-rhxn/msnap";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    import-tree,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;}
    {
      # import-tree is itself callable — pass the directory directly.
      # It returns a flake-parts module that auto-imports every .nix
      # file found under flake-parts/ (subdirectories included).
      imports = [(import-tree ./flake-parts)];

      flake = {
        overlays.default = final: prev: {
          wswitch = prev.callPackage ./packages/wswitch.nix {};
        };
      };

      systems = ["x86_64-linux"];
    };
}
