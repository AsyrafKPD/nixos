{
  inputs,
  self,
  ...
}: {
  flake = {
    nixosConfigurations.aiman = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        system = "x86_64-linux";
      };
      modules = [
        # Host-specific system config — paths anchored to flake root via `self`
        "${self}/hosts/aiman/configuration.nix"

        # Enable the mango WM at system level
        inputs.mango.nixosModules.mango
        {programs.mango.enable = true;}

        # Enable msnap on the system
        {nixpkgs.overlays = [inputs.msnap.overlays.default];}

        {nixpkgs.overlays = [inputs.self.overlays.default];}

        # Home-manager integration
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = {
              inherit inputs;
              system = "x86_64-linux";
            };
            users.asyraf = import "${self}/hosts/aiman/home.nix";
          };
        }
      ];
    };
  };
}
