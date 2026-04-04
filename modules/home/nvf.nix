{
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs.nvf.lib.nvim.dag) entryBefore;
in {
  programs.nvf = {
    enable = true;
    settings.vim = {
      # ============================================================
      # THEME
      # gruvbox-nvim (Lua port) must have setup() called before
      # any plugin configs load, so we hook into the DAG at the
      # "theme" position using entryBefore [ "pluginConfigs" ].
      # termguicolors is set first so highlight groups render correctly.
      # ============================================================
      theme.enable = false;
      startPlugins = [pkgs.vimPlugins.gruvbox-nvim];

      luaConfigRC.gruvbox = entryBefore ["pluginConfigs"] ''
        vim.opt.termguicolors = true        -- must be set before colorscheme
        vim.o.background      = "dark"
        require("gruvbox").setup({
          terminal_colors  = true,
          undercurl        = true,
          underline        = true,
          bold             = true,
          contrast         = "medium",        -- "hard" | "medium" | "soft"
          italic = {
            strings   = true,
            emphasis  = true,
            comments  = true,
            operators = false,
            folds     = true,
          },
          overrides        = {},
          transparent_mode = false,
        })
        vim.cmd("colorscheme gruvbox")
      '';

      # ============================================================
      # CORE OPTIONS
      # ============================================================
      options = {
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true; # spaces instead of tabs
        number = true;
        relativenumber = true;
        termguicolors = true;
        clipboard = "unnamedplus";
        undofile = true; # persistent undo across sessions
        cursorline = true;
        wrap = false; # no line wrapping
        scrolloff = 8; # keep 8 lines above/below cursor
        sidescrolloff = 8;
        signcolumn = "yes"; # always show sign column (no layout shift)
        splitright = true; # vsplit opens to the right
        splitbelow = true; # split opens below
        updatetime = 250; # faster CursorHold events
        timeoutlen = 300; # faster which-key popup
      };

      globals = {
        mapleader = " ";
        maplocalleader = "\\";
      };

      # wl-clipboard provides wl-copy / wl-paste so Neovim can reach
      # the Wayland compositor clipboard via clipboard = "unnamedplus".
      extraPackages = [pkgs.wl-clipboard];

      # ============================================================
      # LANGUAGES — using NVF's native language modules where possible.
      # These handle LSP, treesitter, formatting, and linting together.
      # ============================================================
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true; # nixd + nixfmt
        python.enable = true; # pyright + black
        ts.enable = true; # ts_ls + prettier
        lua.enable = true; # lua_ls + stylua
        bash.enable = true; # bashls + shfmt
        html.enable = true;
        css.enable = true;
        php.enable = true;
        markdown.enable = true;
      };

      # ============================================================
      # LSP — extra config on top of language modules
      # ============================================================
      lsp = {
        enable = true;
        formatOnSave = true;
        lspconfig.enable = true;
      };

      # ============================================================
      # TREESITTER — extra grammars not covered by language modules
      # ============================================================
      treesitter = {
        enable = true;
        highlight.enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          rust
          go
          json
          yaml
          toml
          vim
        ];
      };

      # ============================================================
      # SNIPPETS & AUTOCOMPLETE
      # ============================================================
      snippets.luasnip.enable = true;

      autocomplete.nvim-cmp = {
        enable = true;
        mappings = {
          next = "<C-n>";
          previous = "<C-p>";
          complete = "<C-Space>";
          close = "<C-e>";
          confirm = "<CR>";
        };
        sources = {
          nvim-lsp = "[LSP]";
          buffer = "[Buf]";
          path = "[Path]";
        };
      };

      # ============================================================
      # UI PLUGINS
      # ============================================================
      telescope = {
        enable = true;
        mappings = {
          findFiles = "<leader>ff";
          liveGrep = "<leader>fg";
          buffers = "<leader>fb";
          helpTags = "<leader>fh";
          diagnostics = "<leader>fd";
        };
      };

      filetree.neo-tree.enable = true;

      statusline.lualine = {
        enable = true;
        theme = "gruvbox"; # match the colorscheme
      };

      tabline.nvimBufferline.enable = true; # buffer tabs at the top

      git = {
        gitsigns.enable = true;
        gitsigns.codeActions.enable = true; # stage/reset hunks via code actions
      };

      autopairs.nvim-autopairs.enable = true;
      binds.whichKey.enable = true;
      binds.cheatsheet.enable = true; # searchable cheatsheet of all keymaps

      comments.comment-nvim.enable = true; # gcc / gc to comment

      diagnostics.nvim-lint.enable = true; # async linting

      visuals = {
        indent-blankline.enable = true;
        nvim-web-devicons.enable = true;
        highlight-undo.enable = true; # flash highlight on undo/redo
        fidget-nvim.enable = true; # LSP progress spinner in bottom-right
      };

      # Smooth scrolling + dashboard
      extraPlugins = {
        neoscroll = {
          package = pkgs.vimPlugins.neoscroll-nvim;
          setup = "require('neoscroll').setup({ mappings = {'<C-u>','<C-d>','<C-b>','<C-f>'} })";
        };

        # alpha-nvim: same dashboard plugin LazyVim uses.
        # NixOS snowflake ASCII header with gruvbox-coloured buttons.
        alpha-nvim = {
          package = pkgs.vimPlugins.alpha-nvim;
          after = ["neoscroll"];
          setup = ''
            local alpha     = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            -- MYNIX in ANSI Shadow block letters
            dashboard.section.header.val = {
              "                                                         ",
              "███╗   ███╗  ██╗   ██╗  ███╗   ██╗  ██╗  ██╗  ██╗",
              "████╗ ████║  ╚██╗ ██╔╝  ████╗  ██║  ██║  ╚██╗██╔╝",
              "██╔████╔██║   ╚████╔╝   ██╔██╗ ██║  ██║   ╚███╔╝ ",
              "██║╚██╔╝██║    ╚██╔╝    ██║╚██╗██║  ██║   ██╔██╗ ",
              "██║ ╚═╝ ██║     ██║     ██║ ╚████║  ██║  ██╔╝ ██╗",
              "╚═╝     ╚═╝     ╚═╝     ╚═╝  ╚═══╝  ╚═╝  ╚═╝  ╚═╝",
              "                                                         ",
            }

            -- Buttons matching this config's keymaps
            dashboard.section.buttons.val = {
              dashboard.button("f", "  Find File",    "<cmd>Telescope find_files<cr>"),
              dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<cr>"),
              dashboard.button("g", "  Live Grep",    "<cmd>Telescope live_grep<cr>"),
              dashboard.button("e", "  File Tree",    "<cmd>Neotree toggle<cr>"),
              dashboard.button("c", "  Config",       "<cmd>Telescope find_files cwd=~/.config<cr>"),
              dashboard.button("q", "  Quit",         "<cmd>qa<cr>"),
            }

            dashboard.section.footer.val = "  NixOS  ·  nvf  ·  gruvbox"

            -- Gruvbox highlight colours
            vim.api.nvim_set_hl(0, "AlphaHeader",   { fg = "#d79921" }) -- yellow
            vim.api.nvim_set_hl(0, "AlphaButtons",  { fg = "#83a598" }) -- blue
            vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#fb4934" }) -- red
            vim.api.nvim_set_hl(0, "AlphaFooter",   { fg = "#928374" }) -- grey

            dashboard.section.header.opts.hl  = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.section.footer.opts.hl  = "AlphaFooter"
            for _, btn in ipairs(dashboard.section.buttons.val) do
              btn.opts.hl          = "AlphaButtons"
              btn.opts.hl_shortcut = "AlphaShortcut"
            end

            alpha.setup(dashboard.opts)

            vim.api.nvim_create_autocmd("FileType", {
              pattern  = "alpha",
              callback = function() vim.opt_local.foldenable = false end,
            })
          '';
        };
      };

      # ============================================================
      # UTILITY
      # ============================================================
      utility = {
        surround.enable = true; # cs"' to change surrounding quotes
        motion.leap.enable = true; # s<char><char> to jump anywhere
        diffview-nvim.enable = true; # nice git diff viewer (:DiffviewOpen)
      };

      notes.todo-comments.enable = true; # highlight TODO / FIXME / NOTE

      # ============================================================
      # MISC QUALITY OF LIFE
      # ============================================================
      hideSearchHighlight = true; # clear search highlight after moving
      preventJunkFiles = true; # no swap/backup clutter
      enableLuaLoader = true; # faster Lua require() via bytecode cache

      # ============================================================
      # KEYMAPS — all with desc so which-key shows them in the panel.
      # Press <leader> and wait to see the full grouped menu.
      # ============================================================
      keymaps = [
        # Window movement
        {
          key = "<C-h>";
          action = "<C-w>h";
          mode = "n";
          desc = "Window left";
        }
        {
          key = "<C-j>";
          action = "<C-w>j";
          mode = "n";
          desc = "Window down";
        }
        {
          key = "<C-k>";
          action = "<C-w>k";
          mode = "n";
          desc = "Window up";
        }
        {
          key = "<C-l>";
          action = "<C-w>l";
          mode = "n";
          desc = "Window right";
        }

        # Save
        {
          key = "<C-s>";
          action = "<cmd>w<cr>";
          mode = ["n" "i"];
          desc = "Save file";
        }

        # Better indenting in visual mode
        {
          key = "<";
          action = "<gv";
          mode = "v";
          desc = "Indent left";
        }
        {
          key = ">";
          action = ">gv";
          mode = "v";
          desc = "Indent right";
        }

        # Move selected lines
        {
          key = "<A-j>";
          action = ":m '>+1<CR>gv=gv";
          mode = "v";
          desc = "Move selection down";
        }
        {
          key = "<A-k>";
          action = ":m '<-2<CR>gv=gv";
          mode = "v";
          desc = "Move selection up";
        }

        # Buffer navigation
        {
          key = "<S-l>";
          action = "<cmd>bnext<cr>";
          mode = "n";
          desc = "Next buffer";
        }
        {
          key = "<S-h>";
          action = "<cmd>bprevious<cr>";
          mode = "n";
          desc = "Prev buffer";
        }
        {
          key = "<leader>bd";
          action = "<cmd>bdelete<cr>";
          mode = "n";
          desc = "Delete buffer";
        }

        # File tree
        {
          key = "<leader>e";
          action = "<cmd>Neotree toggle<cr>";
          mode = "n";
          desc = "Toggle file tree";
        }

        # Telescope — <leader>f group
        {
          key = "<leader>ff";
          action = "<cmd>Telescope find_files<cr>";
          mode = "n";
          desc = "Find files";
        }
        {
          key = "<leader>fg";
          action = "<cmd>Telescope live_grep<cr>";
          mode = "n";
          desc = "Live grep";
        }
        {
          key = "<leader>fb";
          action = "<cmd>Telescope buffers<cr>";
          mode = "n";
          desc = "Find buffers";
        }
        {
          key = "<leader>fh";
          action = "<cmd>Telescope help_tags<cr>";
          mode = "n";
          desc = "Help tags";
        }
        {
          key = "<leader>fr";
          action = "<cmd>Telescope oldfiles<cr>";
          mode = "n";
          desc = "Recent files";
        }
        {
          key = "<leader>fd";
          action = "<cmd>Telescope diagnostics<cr>";
          mode = "n";
          desc = "Diagnostics";
        }

        # LSP — <leader>l group
        {
          key = "<leader>lr";
          action = "<cmd>lua vim.lsp.buf.rename()<cr>";
          mode = "n";
          desc = "Rename symbol";
        }
        {
          key = "<leader>la";
          action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
          mode = "n";
          desc = "Code action";
        }
        {
          key = "<leader>lf";
          action = "<cmd>lua vim.lsp.buf.format()<cr>";
          mode = "n";
          desc = "Format buffer";
        }
        {
          key = "<leader>ld";
          action = "<cmd>Telescope diagnostics<cr>";
          mode = "n";
          desc = "List diagnostics";
        }
        {
          key = "gd";
          action = "<cmd>lua vim.lsp.buf.definition()<cr>";
          mode = "n";
          desc = "Go to definition";
        }
        {
          key = "gr";
          action = "<cmd>lua vim.lsp.buf.references()<cr>";
          mode = "n";
          desc = "References";
        }
        {
          key = "K";
          action = "<cmd>lua vim.lsp.buf.hover()<cr>";
          mode = "n";
          desc = "Hover docs";
        }
        {
          key = "[d";
          action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
          mode = "n";
          desc = "Prev diagnostic";
        }
        {
          key = "]d";
          action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
          mode = "n";
          desc = "Next diagnostic";
        }

        # Git — <leader>g group
        {
          key = "<leader>gp";
          action = "<cmd>Gitsigns preview_hunk<cr>";
          mode = "n";
          desc = "Preview hunk";
        }
        {
          key = "<leader>gs";
          action = "<cmd>Gitsigns stage_hunk<cr>";
          mode = "n";
          desc = "Stage hunk";
        }
        {
          key = "<leader>gu";
          action = "<cmd>Gitsigns undo_stage_hunk<cr>";
          mode = "n";
          desc = "Undo stage hunk";
        }
        {
          key = "<leader>gd";
          action = "<cmd>DiffviewOpen<cr>";
          mode = "n";
          desc = "Diff view";
        }
        {
          key = "<leader>gb";
          action = "<cmd>Gitsigns blame_line<cr>";
          mode = "n";
          desc = "Blame line";
        }

        # Todo comments
        {
          key = "]t";
          action = "<cmd>lua require('todo-comments').jump_next()<cr>";
          mode = "n";
          desc = "Next TODO";
        }
        {
          key = "[t";
          action = "<cmd>lua require('todo-comments').jump_prev()<cr>";
          mode = "n";
          desc = "Prev TODO";
        }
        {
          key = "<leader>ft";
          action = "<cmd>TodoTelescope<cr>";
          mode = "n";
          desc = "Find TODOs";
        }

        # Misc
        {
          key = "<leader>q";
          action = "<cmd>qa<cr>";
          mode = "n";
          desc = "Quit all";
        }
        {
          key = "<leader>w";
          action = "<cmd>w<cr>";
          mode = "n";
          desc = "Save file";
        }
        {
          key = "<leader>h";
          action = "<cmd>nohl<cr>";
          mode = "n";
          desc = "Clear highlights";
        }
        {
          key = "<leader>/";
          action = "<cmd>Telescope live_grep<cr>";
          mode = "n";
          desc = "Search in files";
        }
      ];

      # which-key group labels — shown as headers in the popup panel
      luaConfigRC.whichKeyGroups = ''
        local wk = require("which-key")
        wk.add({
          { "<leader>f",  group = "  Find / Telescope" },
          { "<leader>l",  group = "  LSP"              },
          { "<leader>g",  group = "  Git"              },
          { "<leader>b",  group = "  Buffers"          },
        })
      '';
    };
  };
}
