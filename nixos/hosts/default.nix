{ config, lib, pkgs, ... }:

{
  system.stateVersion = "25.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-old +42";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
  ];
}
