[
  {
    Networking = [
      {
        OPNSense = {
          href = "http://10.25.25.1";
          icon = "opnsense.png";
          description = "10.25.25.1";
        };
      }
#      {
#        "Pi-hole" = {
#          href = "http://10.25.25.5/admin";
#          icon = "pi-hole.png";
#          description = "10.25.25.5/admin";
#        };
#      }
      {
        Proxmox = {
          href = "https://10.25.25.4:8006";
          icon = "proxmox.png";
          description = "10.25.25.4:8006";
        };
      }
    ];
  }

  {
    Services = [
      {
        Jellyfin = {
          href = "https://<SERVICE.URL>";
          icon = "jellyfin";
          description = "10.25.25.7:8096";
        };
      }
      {
        Sonarr = {
          href = "https://<SERVICE.URL>";
          icon = "sonarr.png";
          description = "10.25.25.7:8989";
        };
      }
      {
        Radarr = {
          href = "https://<SERVICE.URL>";
          icon = "radarr.png";
          description = "10.25.25.7:7878";
        };
      }
      {
        Prowlarr = {
          href = "https://<SERVICE.URL>";
          icon = "prowlarr.png";
          description = "10.25.25.7:9696";
        };
      }
      {
        Jellyseerr = {
          href = "https://<SERVICE.URL>";
          icon = "jellyseerr.png";
          description = "10.25.25.7:5055";
        };
      }
      {
        Immich = {
          href = "https://<SERVICE.URL>";
          icon = "immich.png";
        };
      }
    ];
  }

  {
    Utilities = [
      {
        Deluge = {
          href = "https://<SERVICE.URL>";
          icon = "deluge.png";
          description = "10.25.25.7:8112";
        };
      }
      {
        Truenas = {
          href = "https://<SERVICE.URL>";
          icon = "truenas.png";
          description = "10.25.25.6";
          widget = {
            type = "truenas";
            url = "http://10.25.25.6";
            username = "root";
            password = "<PASSWORD>";
          };
        };
      }
      {
        Traefik = {
          href = "http://<SERVICE.URL>";
          icon = "traefik.png";
          description = "Currently Enabled in Config";
        };
      }
    ];
  }
]
