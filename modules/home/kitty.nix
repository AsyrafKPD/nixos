{pkgs, ...}: {
  programs.kitty = {
    enable = true;

    # ── Shell integration ──────────────────────────────────────────
    shellIntegration.enableZshIntegration = true;

    # ── Font ──────────────────────────────────────────────────────
    font = {
      name = "MartianMono Nerd Font";
      size = 11;
    };
    themeFile = "GruvboxMaterialDarkMedium";

    # ── Gruvbox Dark theme ─────────────────────────────────────────
    settings = {
      shell = "${pkgs.zsh}/bin/zsh";
      cursor_stop_blinking_after = 7.0;
      scrollback_lines = 999999;
      enable_audio_bell = false;
      mouse_hide_wait = -3.0;
      url_color = "#0087bd";
      url_style = "curly";
      detect_urls = "yes";
      tab_bar_style = "powerline";
    };
  };
}
