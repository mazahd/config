# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./impermanence/nixos.nix

    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  networking.hostId = "e9c11c88"; # For example: head -c 8 /etc/machine-id
  networking.hostName = "nimi"; # Define your hostname.

  users.users.root.initialPassword = "xer";
  users.mutableUsers = false;
  
  zramSwap.enable = true;

  environment.persistence."/persist" = {
  hideMounts = true;
  files = [
    "/etc/machine-id"
  ];

  directories = [
    "/var/log"
  ];
};

  system.stateVersion = "23.05"; # Did you read the comment?

}

