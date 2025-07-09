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
      };
      outputs = {
        "DP-1" = {
          scale = 2.0;
        };
      };
      spawn-at-startup = [
        { command = [ "xwayland-satellite" ]; }
        { command = [ "swww-daemon" ]; }
        { command = [ "mako" ]; }
        { command = [ "waybar" ]; }
        { command = [ "/usr/bin/lxqt-policykit-agent" ]; }
        { command = [ "wl-paste --watch cliphist store" ]; }
      ];
      environment = {
        DISPLAY = ":0";
      };
    };
  };

  programs.waybar = {
    enable = true;
  };

  # Catppuccin theme for Waybar
  catppuccin.waybar = {
    enable = true;
    flavor = "mocha";
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };

  # All your user-specific packages
  home.packages = with pkgs; [
    helix
    git
    jujutsu
    htop
    zellij # terminal multiplexer
    # --- ESSENTIAL HYPRLAND ECOSYSTEM TOOLS ---
    alacritty
    wofi # Application launcher (or pkgs.rofi-wayland)
    waybar # Status bar (highly recommended)
    mako # Notification daemon
    swww # For setting wallpapers
    cliphist # Clipboard history manager
    slurp # For selecting a region for screenshots
    grim # For taking screenshots
    pavucontrol # GUI for PulseAudio/PipeWire volume control
    fd
    ripgrep
    yazi
    gh
    signal-desktop
    xwayland-satellite # for running x11 apps
    nixfmt-rfc-style # nix formatter
    nil # nix language server
    atac # postman-like TUI
    rsync # file sync utility
    udiskie # for mounting external drives
    darktable # photo editing
    zoxide
    chromium

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

  programs.zen-browser.enable = true;
  # programs.swww.enable = true;
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
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
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
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
      theme = "catppuccin_frappe";
      editor = {
        bufferline = "multiple";
        file-picker = {
          hidden = true;
          git-ignore = false;
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
          name = "rust";
          auto-format = true;
          formatter = {
            command = "${pkgs.rustfmt}/bin/rustfmt --edition 2024";
          };
          indent = {
            tab-width = 4;
            unit = "t";
          };
        }
      ];
    };
  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    SUDO_EDITOR = "hx";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_CURRENT_DESKTOP = "Niri";
    XDG_SESSION_TYPE = "wayland";
    SSH_AUTH_SOCK = "~/.1password/agent.sock";
  };

  # Set the state version for Home Manager
  home.stateVersion = "25.05";
}
