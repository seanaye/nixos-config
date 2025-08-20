{
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # xdg.portal = {
  #   enable = true;
  #   xdgOpenUsePortal = true;
  #   config = {
  #     common = {
  #       default = [
  #         "gnome"
  #         "gtk"
  #       ];

  #       "org.freedesktop.impl.portal.ScreenCast" = "gnome";
  #       "org.freedesktop.impl.portal.Screenshot" = "gnome";
  #       "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
  #     };
  #   };

  #   # Specify the backends you want to use.
  #   # The order matters, the first one is the primary.
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-gtk
  #     xdg-desktop-portal-gnome
  #   ];
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.polkit.enable = true;
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

  services.udisks2.enable = true;
  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    ports = [ 5431 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "sean" ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.storage = { };
  users.users.sean = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCIqgZ7kedxo+mOW7YG73Vp3zel3h180y3GKvHtRsXfGlpIIvRDy7pgCBQ4AGXYD4y78URQmFohYSAPqCPOPaWcU2un3XG9KvCzEsHmsbskPonitUmCiKvrKkb6oW4jCBtd7AEtBn+AiajAQFtPZ7NN2Df3AmTypvR6Irg7R+nxnfc9NTIHmGvxSDyWcbb4pguL20sctUSqGL6xGh8q/bqhdOThSimM+z9bEUNxK/5rPhwkNniMrp4pJcUrUiAh5/4DiRFG6KT+oeg+/myoz/Z1sPvAs7u/8JDQI4RshRD8Hu0oTkRBN6Hxj478q2SXbeBUZlD6IdjP3RhGpmSecoDdtWqKbpuV3eVRtQtba3KL86GBeV/bugaOdJ1Aud+1SOFJreAAuvxzMMKT+cdQZk6oOPP148DA/No+mDm/2S43lcdCXh79wA6YRAmKQ8jmZxTCtPutrvuZK1rguvvUlEoG/vhdNHh7eDa4Td07V6bjCRPUl8qk/e4M0E3pwsTlZc="
    ];
    isNormalUser = true;
    description = "Sean Aye";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "video"
      "disk"
      "storage"
      "input"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sean" ];
  };

  programs.steam = {
    enable = true;
  };
  virtualisation.docker.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
    SUDO_EDITOR = "hx";
  };

  # List services that you want to enable:
  nixarr = {
    enable = true;
    mediaDir = "/mnt/storage1/nixarr/media";
    vpn = {
      enable = true;
      wgConf = "/mnt/storage1/nixarr/wireguard.conf";
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    transmission = {
      enable = true;
      vpn.enable = true;
    };
    sabnzbd = {
      enable = true;
      vpn.enable = true;
      openFirewall = true;
    };

    prowlarr.enable = true;
    radarr.enable = true;
    sonarr.enable = true;
    jellyseerr = {
      enable = true;
      openFirewall = true;
    };

    recyclarr = {
      enable = true;
      configuration = {
        sonarr = {
          series = {
            base_url = "http://localhost:8989";
            api_key = "!env_var SONARR_API_KEY";
            quality_definition = {
              type = "series";
            };
            delete_old_custom_formats = true;
            custom_formats = [
              {
                trash_ids = [
                  "85c61753df5da1fb2aab6f2a47426b09" # BR-DISK
                  "9c11cd3f07101cdba90a2d81cf0e56b4" # LQ
                ];
                assign_scores_to = [
                  {
                    name = "WEB-DL (1080p)";
                    score = -10000;
                  }
                ];
              }
            ];
          };
        };
        radarr = {
          movies = {
            base_url = "http://localhost:7878";
            api_key = "!env_var RADARR_API_KEY";
            quality_definition = {
              type = "movie";
            };
            delete_old_custom_formats = true;
            custom_formats = [
              {
                trash_ids = [
                  "570bc9ebecd92723d2d21500f4be314c" # Remaster
                  "eca37840c13c6ef2dd0262b141a5482f" # 4K Remaster
                ];
                assign_scores_to = [
                  {
                    name = "HD Bluray + WEB";
                    score = 25;
                  }
                ];
              }
            ];
          };
        };
      };
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    8096
    5055
    3000
  ];
  networking.firewall.allowedUDPPorts = [
    8096
    5055
    3000
  ];
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
