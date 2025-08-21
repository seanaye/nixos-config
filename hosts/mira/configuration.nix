{
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/common.nix
  ];




  networking.hostName = "mira"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


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


  users.users.sean.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCIqgZ7kedxo+mOW7YG73Vp3zel3h180y3GKvHtRsXfGlpIIvRDy7pgCBQ4AGXYD4y78URQmFohYSAPqCPOPaWcU2un3XG9KvCzEsHmsbskPonitUmCiKvrKkb6oW4jCBtd7AEtBn+AiajAQFtPZ7NN2Df3AmTypvR6Irg7R+nxnfc9NTIHmGvxSDyWcbb4pguL20sctUSqGL6xGh8q/bqhdOThSimM+z9bEUNxK/5rPhwkNniMrp4pJcUrUiAh5/4DiRFG6KT+oeg+/myoz/Z1sPvAs7u/8JDQI4RshRD8Hu0oTkRBN6Hxj478q2SXbeBUZlD6IdjP3RhGpmSecoDdtWqKbpuV3eVRtQtba3KL86GBeV/bugaOdJ1Aud+1SOFJreAAuvxzMMKT+cdQZk6oOPP148DA/No+mDm/2S43lcdCXh79wA6YRAmKQ8jmZxTCtPutrvuZK1rguvvUlEoG/vhdNHh7eDa4Td07V6bjCRPUl8qk/e4M0E3pwsTlZc="
  ];

  programs.steam = {
    enable = true;
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
