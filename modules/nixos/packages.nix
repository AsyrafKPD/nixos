{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xwayland
    wl-clipboard
    grim
    slurp
    foomatic-db-engine
    eog
    wdisplays
    cmatrix
    nitch
    gpu-screen-recorder
    protonplus
    mpv
    onlyoffice-desktopeditors
    vim
    tree
    curl
    git
    fastfetch
    vulkan-tools
    mangohud
    msnap
  ];
}
