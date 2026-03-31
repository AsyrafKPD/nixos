{pkgs, ...}: {
  home.packages = with pkgs; [
    nemo-with-extensions
    nemo-preview
    nemo-fileroller # or gnome.nemo-fileroller depending on nixpkgs version
    nemo-python
    nemo-emblems
    file-roller # the actual archive manager backend
    p7zip
    unzip
    unrar
  ];
}
