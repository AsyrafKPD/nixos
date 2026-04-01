{
  config,
  pkgs,
  ...
}: {
  # ── GTK ───────────────────────────────────────────────────────────
  gtk = {
    enable = true;

    theme = {
      name = "Gruvbox-Material-Dark";
      package = pkgs.gruvbox-material-gtk-theme;
    };

    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    font = {
      name = "Noto Sans";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-button-images = false;
      gtk-menu-images = false;
    };

    gtk4 = {
      # Silence the deprecation warning — keeps GTK4 theme in sync with GTK3
      theme = config.gtk.theme;

      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };

  home.sessionVariables = {
    GTK_THEME = "Gruvbox-Material-Dark";
  };

  # ── Qt — follow GTK theme ─────────────────────────────────────────
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # ── Cursor — also set via home.pointerCursor for Wayland/X11 ─────
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
