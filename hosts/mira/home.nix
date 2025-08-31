{ ... }:

{
  imports = [
    ../common/home.nix
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "esphome"
      "met"
      "radio_browser"
    ];
    config = {
      default_config = { };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8132 ];

}
