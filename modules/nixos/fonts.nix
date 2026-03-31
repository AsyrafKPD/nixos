{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.martian-mono
    nerd-fonts.departure-mono
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
    font-awesome_6
    corefonts
    vista-fonts
    liberation_ttf
  ];
}
