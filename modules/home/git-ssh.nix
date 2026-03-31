{...}: {
  # ── Git ───────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user.name = "AsyrafKPD";
      user.email = "hypixelxclan@gmail.com";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      safe.directory = ["/etc/nixos"];
    };
  };

  # ── SSH ───────────────────────────────────────────────────────────
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    addKeysToAgent = "yes";
    matchBlocks = {
      # Example host block — add your own below
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
