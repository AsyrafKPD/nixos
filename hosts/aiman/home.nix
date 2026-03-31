{ inputs, ... }: {
  imports = [
    ../../modules/home

    # External home-manager modules
    inputs.mango.hmModules.mango
    inputs.noctalia.homeModules.default
    inputs.nvf.homeManagerModules.default
  ];

  home = {
    username = "asyraf";
    homeDirectory = "/home/asyraf";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
