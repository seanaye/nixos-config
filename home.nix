# This is the configuration for your user 'sean'
{ pkgs, inputs, ... }:

{
  # Import the home-manager modules you want to use
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.niri.homeModules.niri
    inputs.zen-browser.homeModules.beta
  ];

  # Niri window manager settings, now controlled by the imported module
  programs.niri = {
    enable = true;
    settings = {
      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 12.0;
            top-right = 12.0;
            bottom-left = 12.0;
            bottom-right = 12.0;
          };
          clip-to-geometry = true;
        }
      ];
      layout = {
        struts = {
          top = 0;
          bottom = 0;
        };
      };
      gestures = {
        hot-corners = {
          enable = false;
        };
      };
      binds = {
        "Mod+d".action.spawn = [
          "wofi"
          "--show"
          "drun"
          "--prompt"
          "Search..."
        ];
        "Mod+a".action.spawn = "alacritty";
        "Mod+h".action = {
          focus-column-left = { };
        };
        "Mod+j".action = {
          focus-workspace-down = { };
        };
        "Mod+k".action = {
          focus-workspace-up = { };
        };
        "Mod+l".action = {
          focus-column-right = { };
        };
        "Mod+Shift+h".action = {
          move-column-left = { };
        };
        "Mod+Shift+j".action = {
          move-window-down-or-to-workspace-down = { };
        };
        "Mod+Shift+k".action = {
          move-window-up-or-to-workspace-up = { };
        };
        "Mod+Shift+l".action = {
          move-column-right = { };
        };
        "Mod+Down".action = {
          move-workspace-down = { };
        };
        "Mod+Up".action = {
          move-workspace-up = { };
        };
        "Mod+p".action = {
          show-hotkey-overlay = { };
        };
        "Mod+o".action = {
          toggle-overview = { };
        };
        "Mod+q".action = {
          close-window = { };
        };
        "Mod+s".action = {
          screenshot = {
            show-pointer = true;
          };
        };
        "Mod+1".action = {
          set-column-width = "100%";
        };
        "Mod+2".action = {
          set-column-width = "50%";
        };
        "XF86MonBrightnessDown".action.spawn = [
          "brightnessctl"
          "set"
          "5%-"
        ];
        "XF86MonBrightnessUp".action.spawn = [
          "brightnessctl"
          "set"
          "+5%"
        ];
      };
      outputs = {
        "DP-1" = {
          scale = 2.0;
        };
        "DP-7" = {
          scale = 2.0;
        };
      };
      spawn-at-startup = [
        { command = [ "xwayland-satellite" ]; }
        { command = [ "swww-daemon" ]; }
        { command = [ "mako" ]; }
        { command = [ "waybar" ]; }
        { command = [ "wl-paste --watch cliphist store" ]; }
      ];
      environment = {
        DISPLAY = ":0";
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];

  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  programs.waybar = {
    enable = true;

    style = builtins.readFile ./waybar/style.css;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.awscli = {
    enable = true;
    settings = {
      "default" = {
        region = "us-east-2";
      };
    };
  };

  # All your user-specific packages
  home.packages = with pkgs; [
    helix
    git
    jujutsu # jj-cli
    htop
    zellij # terminal multiplexer
    alacritty
    wofi # Application launcher (or pkgs.rofi-wayland)
    waybar # Status bar (highly recommended)
    mako # Notification daemon
    swww # For setting wallpapers
    cliphist # Clipboard history manager
    pavucontrol # GUI for PulseAudio/PipeWire volume control
    fd
    ripgrep
    yazi # tui file browser
    gh # github cli
    signal-desktop
    xwayland-satellite # for running x11 apps
    nixfmt-rfc-style # nix formatter
    nil # nix language server
    atac # postman-like TUI
    trippy # network analyzer
    rsync # file sync utility
    udiskie # for mounting external drives
    # darktable # photo editing
    zoxide
    chromium
    claude-code
    nautilus # file browser
    sqlitebrowser
    gnome-characters # symbol picker
    sendme # file transfer
    desktop-file-utils # for managing .desktop files
    flyctl # fly.io cli
    vscode-json-languageserver
    gnome-network-displays
    doppler # secret management

    # --- FONTS ARE IMPORTANT ---
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome # For icons in waybar, etc.
    nerd-fonts.jetbrains-mono
    # --- POLKIT AGENT (for 1Password GUI, etc.) ---
    lxqt.lxqt-policykit # Lightweight polkit agent
  ];

  services.udiskie = {
    enable = true;
    tray = "auto";
    automount = true;
  };

  programs.direnv.enable = true;

  programs.zellij = {
    enable = true;
    settings = {
      keybinds = {
        unbind = [ "Ctrl q" ];
      };
      ui = {
        pane_frames = false;
      };
    };
  };

  programs.zen-browser.enable = true;
  # programs.swww.enable = true;
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
    ];
  };

  # Program configurations
  programs.git = {
    enable = true;
    userName = "seanaye";
    userEmail = "hello@seanaye.ca";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  programs.jujutsu = {
    enable = true;
    settings.user = {
      email = "hello@seanaye.ca";
      name = "Sean Aye";
    };
  };

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      # Load 1Password CLI plugins
      if test -f ~/.config/op/plugins.sh
        source ~/.config/op/plugins.sh
      end
    '';
    functions = {
      s3edit = ''
        set file (basename $argv[1])
        set tmpfile /tmp/$file
        aws s3 cp $argv[1] $tmpfile
        and $EDITOR $tmpfile
        and aws s3 cp $tmpfile $argv[1]
      '';
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  catppuccin = {
    enable = true;
    flavor = "frappe";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
      };
    };

  };

  programs.helix = {
    enable = true;
    settings = {
      editor = {
        bufferline = "multiple";
        file-picker = {
          hidden = false;
          git-ignore = true;
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        line-number = "relative";
        cursorline = true;
        auto-format = true;
        end-of-line-diagnostics = "hint";
        soft-wrap = {
          enable = true;
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
          display-progress-messages = true;
        };
        inline-diagnostics = {
          cursor-line = "hint";
        };
      };
      keys = {
        normal = {
          esc = [
            "keep_primary_selection"
            "collapse_selection"
          ];
        };

      };
    };
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          };
        }
        {
          name = "kotlin";
          auto-format = true;
        }
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = "rustfmt";
            args = [
              "--edition"
              "2024"
            ];
          };
          indent = {
            tab-width = 4;
            unit = "t";
          };
        }
        {
          name = "astro";
          auto-format = true;
          formatter = {
            command = "npx";
            args = [
              "prettier"
              "--plugin"
              "prettier-plugin-astro"
              "--parser"
              "astro"
            ];
          };
        }
        {
          name = "json";
          auto-format = true;
        }
      ];
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    SUDO_EDITOR = "hx";
    SSH_AUTH_SOCK = "~/.1password/agent.sock";
  };

  # Set the state version for Home Manager
  home.stateVersion = "25.05";
}
