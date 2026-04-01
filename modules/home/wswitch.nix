{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    wswitch
    gnome-themes-extra
  ];

  home.file = {
    ".icons/Gruvbox-Plus-Dark".source = "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark";
    ".icons/Adwaita".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
  };
  xdg.configFile."wswitch/config.ini".text = ''
    # wswitch Switcher Configuration
    [general]
    mode = context
    show_workspace_badge = true

    [theme]
    background = #32302f
    card_bg = #3c3836
    card_selected = #504945
    text_color = #d4be98
    subtext_color = #a89984
    border_color = #e78a4e

    [icons]
    theme = Gruvbox-Plus-Dark
    fallback = Adwaita
    show_letter_fallback = true

    [font]
    family = DepartureMono Nerd Font
    weight = Bold
    title_size = 10
    icon_letter_size = 24
  '';
}
