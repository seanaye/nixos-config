# This is the configuration for your user 'sean'
{ pkgs, inputs, ... }:

{
  # Import the home-manager modules you want to use
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.niri.homeModules.niri
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
      };
      outputs = {
        "DP-1" = {
          scale = 2.0;
        };
      };
      spawn-at-startup = [
        { command = [ "xwayland-satellite" ]; }
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

  # All your user-specific packages
  home.packages = with pkgs; [
    atool
    httpie
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
    swaybg # For setting wallpapers (or pkgs.hyprpaper, pkgs.swww)
    cliphist # Clipboard history manager
    slurp # For selecting a region for screenshots
    grim # For taking screenshots
    pavucontrol # GUI for PulseAudio/PipeWire volume control
    fd
    ripgrep
    yazi
    firefox
    gh
    signal-desktop
    xwayland-satellite
    nixfmt-rfc-style
    nil

    # --- FONTS ARE IMPORTANT ---
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome # For icons in waybar, etc.
    nerd-fonts.jetbrains-mono
    # --- POLKIT AGENT (for 1Password GUI, etc.) ---
    lxqt.lxqt-policykit # Lightweight polkit agent
  ];

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

  programs.helix = {
    enable = true;
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
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
  };

  # Set the state version for Home Manager
  home.stateVersion = "25.05";
}
