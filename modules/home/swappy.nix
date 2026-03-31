#{pkgs, ...}: {
#  home.packages = with pkgs; [
#    swappy
#  ];

#  xdg.configFile."swappy/config".text = ''
#    [Default]
#    save_dir=$HOME/Pictures/Screenshots
#    save_filename_format=%Y%m%d-%H%M%S.png
#    show_panel=true
#    line_size=5
#    text_size=20
#    text_font=JetBrainsMono Nerd Font
#    paint_mode=brush
#    early_exit=true
#    fill_shape=false
#  '';
#}
