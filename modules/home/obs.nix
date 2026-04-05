{pkgs, ...}: {
  home.packages = with pkgs; [
    obs-studio
    obs-studio-plugins.wlrobs
    obs-studio-plugins.waveform
    obs-studio-plugins.obs-vaapi
    obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.obs-markdown
  ];
}
