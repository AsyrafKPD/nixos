{...}: {
  perSystem = {pkgs, ...}: {
    packages.mypackage = pkgs.sl;
    packages.wswitch = pkgs.callPackage ../packages/wswitch.nix {};
  };
}
