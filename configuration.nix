{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # home-manager is now imported via the flake's modules list
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };


   services.greetd = {
     enable = true;
     settings = {
       default_session = {
         command = "${pkgs.hyprland}/bin/Hyprland";
         user = "sean"; # Your username
       };
     };
     # Example with regreet (graphical)
     package = pkgs.greetd.regreet;
     # Or tuigreet (console)
     # package = pkgs.greetd.tuigreet;
   };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  
  
   
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sean = {
    isNormalUser = true;
    description = "Sean Aye";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };
  home-manager.backupFileExtension = "backup";
  home-manager.users.sean = { pkgs, ...}: {
    home.packages = [
      pkgs.atool
      pkgs.httpie
      pkgs.helix
      pkgs.jujutsu

      # --- ESSENTIAL HYPRLAND ECOSYSTEM TOOLS ---
      pkgs.alacritty # Terminal emulator (popular choice, or pkgs.alacritty, pkgs.foot)
      pkgs.wofi # Application launcher (or pkgs.rofi-wayland)
      pkgs.waybar # Status bar (highly recommended)
      pkgs.mako # Notification daemon
      pkgs.swaybg # For setting wallpapers (or pkgs.hyprpaper, pkgs.swww)
      pkgs.swaylock-effects # Screen locker (or pkgs.hyprlock)
      # pkgs.swayidle # Idle management daemon (configure later)
      pkgs.cliphist # Clipboard history manager
      pkgs.slurp # For selecting a region for screenshots
      pkgs.grim # For taking screenshots
      pkgs.pavucontrol # GUI for PulseAudio/PipeWire volume control

      # --- FONTS ARE IMPORTANT ---
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-emoji
      pkgs.font-awesome # For icons in waybar, etc.
      pkgs.nerd-fonts.jetbrains-mono

      # --- POLKIT AGENT (for 1Password GUI, etc.) ---
      pkgs.lxqt.lxqt-policykit # Lightweight polkit agent
    ];
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "hello@seanaye.ca";
          name = "Sean Aye";
        };
      };
    };
    home.sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      SUDO_EDITOR = "hx";
      # --- WAYLAND SPECIFIC ENV VARS ---
      NIXOS_OZONE_WL = "1"; # May help some electron apps use Wayland
      QT_QPA_PLATFORM = "wayland;xcb"; # Prefer Wayland for Qt, fallback to xcb (XWayland)
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # If you want Hyprland to draw all decorations
      SDL_VIDEODRIVER = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
    programs.home-manager.enable = true;
    programs.helix.enable = true;
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

    
    # --- HYPRLAND CONFIGURATION FILES ---
    # This tells home-manager to place your hyprland.conf in ~/.config/hypr/
    # You will need to create the actual file (see step 2 below)
    xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf; # Points to a file named hyprland.conf in the same directory as your configuration.nix

    home.stateVersion = "25.05";
  };


  # Install firefox.
  programs.firefox.enable = true;
  programs.fish.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["sean"];
  };

  programs.steam = {
    enable = true;
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    wl-clipboard
  ];
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
    SUDO_EDITOR = "hx";
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
