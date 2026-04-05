{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  # ── User ──────────────────────────────────────────────────────────
  users.users.asyraf = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "wwwrun" "video" "render"];
    packages = with pkgs; [tree];
  };

  # ── User ──────────────────────────────────────────────────────────
  systemd.tmpfiles.rules = [
    "d /var/www      0755 root   root   - -"
    "Z /var/www/html 2775 wwwrun wwwrun - -"
  ];

  # ── Nix ───────────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # ── Boot ──────────────────────────────────────────────────────────
  boot.loader.limine.enable = true;
  boot.loader.limine.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "loglevel=3"
    "quiet"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
    "vt.global_cursor_default=0"
    "log_buf_len=1M"
    "i915.enable_fbc=1" # framebuffer compression
    "i915.enable_psr=0" # disable panel self-refresh (common stutter cause!)
    "i915.enable_guc=2" # enable GuC/HuC firmware
  ];
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "kernel.split_lock_mitigate" = 0; # reduces penalty for unaligned memory access in games
  };
  boot.plymouth.enable = true;
  boot.plymouth.theme = "spinner";
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # ── Networking ────────────────────────────────────────────────────
  networking.hostName = "aiman";
  networking.networkmanager.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # ── Locale ────────────────────────────────────────────────────────
  time.timeZone = "Asia/Kuala_Lumpur";

  # ── Services ──────────────────────────────────────────────────────
  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
  };

  services.libinput.enable = true;

  services.displayManager.ly = {
    enable = true;
    settings = {
      animate = true;
      animation = "matrix";
      bigclock = true;
      load = true;
      clock = "%d-%m-%Y %H:%M:%S";
      hide_key_hints = true;
      blank_box = true;
      hide_borders = false;
      max_desktop_len = 100;
      max_login_len = 255;
      max_password_len = 255;
      input_len = 40;
      margin_box_h = 6;
      margin_box_v = 3;
      fg = 8;
      bg = 0;
    };
  };

  services.gnome.gnome-keyring.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # ── Programs ──────────────────────────────────────────────────────
  programs.firefox.enable = true;
  programs.system-config-printer.enable = true;
  programs.xwayland.enable = true;
  programs.dconf.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # ── Power ──────────────────────────────────────────────────────
  powerManagement.cpuFreqGovernor = "performance";

  # ── Security ──────────────────────────────────────────────────────
  security.polkit.enable = true;
  security.sudo.extraConfig = ''
    Defaults env_keep += "WAYLAND_DISPLAY XDG_RUNTIME_DIR"
  '';
  security.rtkit.enable = true;

  # ── Hardware ──────────────────────────────────────────────────────
  hardware.bluetooth.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      intel-compute-runtime
      libva-vdpau-driver
    ];
  };

  hardware.enableAllFirmware = true;

  # ── Session environment ───────────────────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "iHD";
  };

  system.stateVersion = "25.11";
}
