{pkgs, ...}: {
  home.packages = with pkgs; [
    vscodium
    vscode-extensions.sainnhe.gruvbox-material
    vscode-extensions.ecmel.vscode-html-css
    vscode-extensions.bradgashler.htmltagwrap
    vscode-extensions.gencer.html-slim-scss-css-class-completion
    vscode-extensions.bierner.color-info
    vscode-extensions.xdebug.php-debug
    vscode-extensions.bmewburn.vscode-intelephense-client
    vscode-extensions.vscjava.vscode-java-pack
    vscode-extensions.dbaeumer.vscode-eslint
    vscode-extensions.bierner.comment-tagged-templates
    vscode-extensions.kamadorueda.alejandra
    vscode-extensions.jeff-hykin.better-nix-syntax
    vscode-extensions.oops418.nix-env-picker
    vscode-extensions.pkief.material-icon-theme
    vscode-extensions.pkief.material-icon-theme
  ];
}
