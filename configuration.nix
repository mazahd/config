# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./impermanence/nixos.nix
      ./initrd.nix

    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-path/pci-0000:00:10.0-scsi-0:0:0:0-part2";
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  networking.hostId = "e9c11c88"; # For example: head -c 8 /etc/machine-id

  users.users.root.initialPassword = "xer";
  users.mutableUsers = false;
  
  zramSwap.enable = true;

  services.openssh = {
  enable = true;
  openFirewall = true;
  passwordAuthentication = true;
  kbdInteractiveAuthentication = false;
  hostKeys = [
    {
      bits = 4096;
      path = "/persist/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
    }
    {
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];
};

users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgtiyDGe+vYeazvXepFiKgOqL1KbDdHAmffPe9Lu+uZ radbellatrix@gmail.com" ]

  environment.persistence."/persist" = {
  hideMounts = true;
  files = [
    "/etc/machine-id"
  ];

  directories = [
    "/var/log"
  ];
};


{
  environment.systemPackages = with pkgs; [
    git
    helix
    tmux
  ];




  system.stateVersion = "23.05"; # Did you read the comment?

}

