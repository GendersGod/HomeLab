# scp -q /home/nick/Documents/VScodium/CoopNetConf/services.nix nick@10.25.25.7:/home/nick/modules
{ config, lib, pkgs, ... }: {
  services = {
    openssh.enable = true;

    homepage-dashboard = {
      enable = true;
      listenPort = 3000;
      openFirewall = true;
      allowedHosts = "<HOSTNAME>";
      settings = import ./homepage/settings.nix;
      bookmarks = import ./homepage/bookmarks.nix;
      widgets = import ./homepage/widgets.nix;
      services = import ./homepage/services.nix;
    };

    deluge = {
      enable = true;
      openFirewall = true;
      config = {
        download_location = "/mnt/CoopNet/Downloads";
        listen_ports = [ 6881 6890 ];
      };
    };
    deluge.web = {
      enable = true;
      openFirewall = true;
      port = 8112;
    };

    jellyfin = {
      enable = true;
      group = "jellyfin";
      user = "jellyfin";
      openFirewall = true;
      dataDir = "/var/lib/jellyfin";
      configDir = "/var/lib/jellyfin/config";
      logDir = "/var/lib/jellyfin/log";
      cacheDir = "/var/cache/jellyfin";
    };

    prowlarr = {
      enable = true;
      openFirewall = true;
      dataDir = "/var/lib/prowlarr";
    };

    flaresolverr = {
      enable = true;
      openFirewall = true;
    };

    radarr = {
      enable = true;
      openFirewall = true;
      dataDir = "/var/lib/radarr";
    };

    sonarr = {
      enable = true;
      openFirewall = true;
      dataDir = "/var/lib/sonarr";
    };

    jellyseerr = {
      enable = true;
      openFirewall = true;
      port = 5055;
    };

    ############### Immich Region ###############
    immich = {
      enable = true;
      host = "0.0.0.0";
      port = 2283;
      secretsFile = "/etc/immich/immich.env";
      mediaLocation = "/mnt/CoopNet/Photos/Uploads";
      openFirewall = true;
      accelerationDevices = [ "/dev/dri/renderD128" ];
      environment = {
        IMMICH_LOG_LEVEL = "debug";
      };
      settings = {
        newVersionCheck.enable = true;
      };
      redis.enable = true;
      machine-learning.enable = false;
      database = {
        user = "immich";
        name = "immich";
        host = "localhost";
        port = 5432;
      };
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      ensureDatabases = [ "immich" ];
      ensureUsers = [
        {
          name = "immich";
          ensureDBOwnership = true;
        }
      ];
    };
    ############ End Immich Region ##############
  }; # Service closer
  environment.etc = {
    "immich/immich.env".text = ''
      DB_USER=immich
      DB_PASSWORD=postgres
      DB_DATABASE_NAME=immich
    '';
    "immich/immich.env".mode = "0600";
    # "homepage-dashboard/background.png".source = backgroundImage;
  };
}
