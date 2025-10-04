# scp -q /home/nick/Documents/VScodium/CoopNetConf/configuration.nix nick@10.25.25.7:/home/nick/
{ config, lib, pkgs, ... }: {
  
  imports = [
    ./hardware-configuration.nix
    ./modules/networking.nix
    ./modules/services.nix
  ];

  ### SYSTEM PARAMETERS ###
  system.stateVersion = "24.11";
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config.allowUnfree = true;
  boot.supportedFilesystems = [ "nfs" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ### ENVIRONMENT ###
  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
    variables = {
      TERM = "xterm-256color";
    };
    systemPackages = with pkgs; [
      git
      wget
      kitty.terminfo
      pciutils
      libva-utils
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
  };

  ### GPU INTEL DRIVERS ###
  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.linux-firmware ];
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
        intel-compute-runtime
        vpl-gpu-rt
      ];
    };
  };

  ### NFS MOUNT & USERS ###
  fileSystems."/mnt/CoopNet" = {
    device = "10.25.25.6:/mnt/Media/Media";
    fsType = "nfs";
    options = [ "rw" "vers=3" "noatime" ];
  };

  ### USERS ###
  users.groups.nfsusers = {
    gid = 3002;
  };

  users.users = {
    nick = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "nfsusers" ];
    };
    deluge.extraGroups = [ "nfsusers" ];
    radarr.extraGroups = [ "nfsusers" ];
    sonarr.extraGroups = [ "nfsusers" ];
    jellyfin.extraGroups = [ "video" "nfsusers" ];
    immich.extraGroups = [ "nfsusers" ];
    postgres.extraGroups = [ "nfsusers" ];
  };
}