{
  config,
  pkgs,
  lib,
  ...
}: {
  # ─────────────────────────────────────────────
  #  Packages — tools wired into the shell
  # ─────────────────────────────────────────────
  home.packages = with pkgs; [
    oh-my-posh # prompt engine
    fzf # fuzzy finder
    zoxide # smarter cd
    eza # modern ls
    bat # better cat
    fd # fast find
    ripgrep # fast grep
    delta # better git diff pager
    direnv # per-dir env vars
    nix-direnv # direnv + nix flake support
    atuin # shell history sync / search
    zsh-completions # extra completion definitions
  ];

  # ─────────────────────────────────────────────
  #  Oh My Posh — gruvbox prompt
  # ─────────────────────────────────────────────
  programs.oh-my-posh = {
    enable = true;
    settings = {
      "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      version = 2;
      final_space = true;
      console_title_template = "{{ .Shell }} in {{ .Folder }}";

      # Replaces accepted prompt with a clean arrow
      transient_prompt = {
        foreground = "#ebdbb2";
        background = "transparent";
        template = "╰──>> ";
      };

      blocks = [
        # ── Line 1: user > path > git ──────────────────────────────
        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [
            # [user@hostname]
            {
              type = "session";
              style = "plain";
              foreground = "#b8bb26";
              background = "transparent";
              template = "[{{ .UserName }}@{{ .HostName }}]";
            }
            # NixOS logo
            {
              type = "os";
              style = "plain";
              foreground = "#83a598";
              background = "transparent";
              template = " {{ .Icon }} ";
            }
            # separator
            {
              type = "text";
              style = "plain";
              foreground = "#a89984";
              background = "transparent";
              template = " > ";
            }
            # directory with folder icons via mapped_locations
            {
              type = "path";
              style = "plain";
              foreground = "#fabd2f";
              background = "transparent";
              template = "{{ .Path }}";
              properties = {
                style = "agnoster_short";
                max_depth = 4;
                folder_separator = "/";
                mapped_locations = {
                  "~" = " ~";
                  "~/Downloads" = " Downloads";
                  "~/Documents" = " Documents";
                  "~/Desktop" = " Desktop";
                  "~/Music" = " Music";
                  "~/Pictures" = " Pictures";
                  "~/Videos" = " Videos";
                  "~/.config" = " .config";
                  "~/.local" = " .local";
                  "~/dev" = " dev";
                  "~/projects" = " projects";
                  "~/repos" = " repos";
                  "/etc" = " etc";
                  "/nix" = " nix";
                  "/tmp" = " tmp";
                };
              };
            }
            # git (only shows inside a repo)
            {
              type = "git";
              style = "plain";
              foreground = "#8ec07c";
              background = "transparent";
              foreground_templates = [
                "{{ if or (.Working.Changed) (.Staging.Changed) }}#fb4934{{ end }}"
                "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#d3869b{{ end }}"
                "{{ if gt .Ahead 0 }}#83a598{{ end }}"
              ];
              template = " > {{ .UpstreamIcon }}{{ .HEAD }}{{ if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}";
              properties = {
                branch_max_length = 25;
                fetch_status = true;
                fetch_upstream_icon = true;
              };
            }
          ];
        }
        # ── Line 2: arrow prompt ────────────────────────────────────
        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [
            {
              type = "text";
              style = "plain";
              foreground_templates = [
                "{{ if gt .Code 0 }}#fb4934{{ end }}"
              ];
              foreground = "#b8bb26";
              background = "transparent";
              template = "╰──>> ";
            }
          ];
        }
      ];
    };
  };

  # ─────────────────────────────────────────────
  #  Atuin — better shell history
  # ─────────────────────────────────────────────
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = false;
      update_check = false;
      style = "compact";
      inline_height = 20;
      filter_mode_shell_up_key_binding = "session";
    };
  };

  # ─────────────────────────────────────────────
  #  Direnv — per-directory environments
  # ─────────────────────────────────────────────
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # ─────────────────────────────────────────────
  #  Zsh — main config
  # ─────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    # ── History ──────────────────────────────────────────────────
    history = {
      size = 100000;
      save = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    autocd = true;
    enableCompletion = true;

    # ── Plugins ──────────────────────────────────────────────────
    plugins = [
      {
        # Syntax highlighting — must come BEFORE substring-search
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        # Fish-style autosuggestions
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        # History substring search (↑/↓)
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
      {
        # fzf-powered completion menu
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    # ── initContent — runs at end of .zshrc ──────────────────────
    initContent = ''
      # ── Completion styling ──────────────────────────────────────
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*:git-checkout:*' sort false

      # fzf-tab previews
      zstyle ':fzf-tab:complete:cd:*'  fzf-preview 'eza --tree --color=always $realpath 2>/dev/null | head -50'
      zstyle ':fzf-tab:complete:ls:*'  fzf-preview 'eza --color=always $realpath 2>/dev/null'
      zstyle ':fzf-tab:complete:cat:*' fzf-preview 'bat --color=always $realpath 2>/dev/null'
      zstyle ':fzf-tab:*' switch-group ',' '.'

      # ── Key bindings ────────────────────────────────────────────
      bindkey -e
      bindkey '^[[A' history-substring-search-up      # ↑
      bindkey '^[[B' history-substring-search-down    # ↓
      bindkey '^[[1;5C' forward-word                  # Ctrl→
      bindkey '^[[1;5D' backward-word                 # Ctrl←
      bindkey '^[[3~'   delete-char                   # Del
      bindkey '^ '      autosuggest-accept            # Ctrl-Space

      # ── fzf ─────────────────────────────────────────────────────
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh

      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
      export FZF_DEFAULT_OPTS="
        --height 40%
        --layout=reverse
        --border=rounded
        --info=inline
        --preview-window=right:55%:wrap
        --color=fg:#ebdbb2,bg:#282828,hl:#fabd2f
        --color=fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
        --color=info:#83a598,prompt:#fabd2f,pointer:#fb4934
        --color=marker:#b8bb26,spinner:#fb4934,header:#83a598
      "
      export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :100 {}'"
      export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -50'"

      # ── zoxide ───────────────────────────────────────────────────
      eval "$(zoxide init zsh --cmd cd)"

      # Ctrl+Z = zoxide interactive picker (must be a zle widget)
      function _zoxide_zi_widget() {
        zi
        zle reset-prompt
      }
      zle -N _zoxide_zi_widget
      bindkey '^Z' _zoxide_zi_widget

      # ── bat ─────────────────────────────────────────────────────
      export BAT_THEME="gruvbox-dark"
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"

      # ── delta (git pager) ────────────────────────────────────────
      export GIT_PAGER="delta"

      # ── autosuggestion style ─────────────────────────────────────
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70,bold"

      # ── Options ─────────────────────────────────────────────────
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT
      setopt CORRECT
      setopt EXTENDED_GLOB
      setopt GLOB_DOTS
      setopt NO_BEEP
      setopt INTERACTIVE_COMMENTS

      # ── Keybind cheatsheet — Ctrl+K ──────────────────────────────
      function _show_keybinds() {
        local binds=(
          "── Navigation ──────────────────────────────"
          "  Ctrl+Space / →    Accept autosuggestion"
          "  Ctrl+→            Forward word"
          "  Ctrl+←            Backward word"
          "  Del               Delete char"
          ""
          "── History ─────────────────────────────────"
          "  ↑ / ↓             History substring search"
          "  Ctrl+R            Atuin history search"
          ""
          "── FZF ─────────────────────────────────────"
          "  Ctrl+T            Fuzzy find file (insert path)"
          "  Alt+C             Fuzzy cd into directory"
          "  Tab               Fuzzy completion (fzf-tab)"
          "  Ctrl+Z            Zoxide interactive jump"
          ""
          "── Aliases — Files ─────────────────────────"
          "  ls                eza (icons)"
          "  ll                eza long + git"
          "  la                eza long + hidden"
          "  lt                eza tree (2 levels)"
          "  lta               eza tree + hidden"
          "  cat               bat (no paging)"
          "  less              bat"
          "  grep              ripgrep (rg)"
          ""
          "── Aliases — Git ───────────────────────────"
          "  g                 git"
          "  gs                git status"
          "  ga                git add"
          "  gc                git commit"
          "  gp                git push"
          "  gl                git log (graph)"
          "  gd                git diff"
          ""
          "── Aliases — Zoxide ────────────────────────"
          "  z <query>         smart jump"
          "  zi                interactive fzf picker"
          ""
          "── Aliases — Nix ───────────────────────────"
          "  nrs               nixos-rebuild switch"
          "  nrt               nixos-rebuild test"
          "  hms               home-manager switch"
          "  nfp               nix flake update"
          "  nsh               nix shell"
          "  nrun              nix run"
          "  ncg               sudo nix-collect-garbage -d"
          ""
          "── Aliases — Editor ────────────────────────"
          "  nv                nvim"
          "  snv               sudo nvim"
          "  code              codium"
          "  scode             sudo codium"
          "  sucode            sudo codium ./ --no-sandbox --user-data-dir"
          ""
          "── Aliases — Utils ─────────────────────────"
          "  mkdir             mkdir -p"
          "  cp                cp -iv"
          "  mv                mv -iv"
          "  rm                rm -Iv"
          "  clr               clear"
          "  dh                dir stack (top 10)"
        )
        printf '%s\n' "''${binds[@]}" | fzf \
          --no-sort \
          --no-multi \
          --prompt "  keybinds > " \
          --header "Ctrl+C to close  |  type to filter" \
          --color "header:#83a598,prompt:#fabd2f,pointer:#fb4934" \
          --color "fg:#ebdbb2,bg:#282828,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f" \
          --preview-window=hidden \
          --height=80%
        zle reset-prompt
      }
      zle -N _show_keybinds
      bindkey '^K' _show_keybinds
    '';

    # ── Aliases ──────────────────────────────────────────────────
    shellAliases = {
      # eza (ls replacement)
      ls = "eza --icons --group-directories-first";
      ll = "eza -lh --icons --group-directories-first --git";
      la = "eza -lah --icons --group-directories-first --git";
      lt = "eza --tree --icons --level=2";
      lta = "eza --tree --icons --level=2 -a";

      # bat (cat replacement)
      cat = "bat --paging=never";
      less = "bat";

      # ripgrep
      grep = "rg";

      # git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph --decorate";
      gd = "git diff";

      # navigation (builtin cd bypasses zoxide)
      ".." = "builtin cd ..";
      "..." = "builtin cd ../..";
      ".4" = "builtin cd ../../..";
      "-" = "builtin cd -";

      # zoxide — uses actual zoxide CLI so they always work
      z = "cd"; # smart jump (zoxide)
      zi = "cdi"; # interactive fzf picker
      za = "zoxide add"; # add a dir to the db
      zq = "zoxide query"; # query without jumping
      zr = "zoxide remove"; # remove a dir from the db

      # nix
      nrs = "sudo nixos-rebuild switch --flake";
      nrt = "sudo nixos-rebuild test --flake";
      hms = "home-manager switch --flake";
      nfp = "sudo nix flake update";
      nsh = "nix shell";
      nrun = "nix run";
      ncg = "sudo nix-collect-garbage -d";

      # editor
      nv = "nvim";
      snv = "sudo nvim";
      code = "codium";
      scode = "sudo codium --no-sandbox --user-data-dir";
      sucode = "sudo codium ./ --no-sandbox --user-data-dir";

      # misc
      which = "type -a";
      mkdir = "mkdir -p";
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -Iv";
      dh = "dirs -v | head -10";
      clr = "clear";
    };

    # ── Session variables ─────────────────────────────────────────
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "bat";
      TERM = "xterm-256color";
      COLORTERM = "truecolor";
    };
  };

  # ─────────────────────────────────────────────
  #  XDG dirs — keep $HOME clean
  # ─────────────────────────────────────────────
  xdg.enable = true;
}
