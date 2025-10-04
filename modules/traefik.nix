# scp -q /home/nick/Documents/VScodium/CoopNetConf/traefik.nix nick@10.25.25.7:/home/nick/modules/traefik.nix
{
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      log = {
        level = "WARN";
      };
      api = {}; # enable API handler
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
        };
      };
      certificatesResolvers = {
        cloudflare = {
          acme = {
            email = "<EMAIL>";
            storage = "/var/lib/traefik/acme.json";
            caserver = "https://acme-v02.api.letsencrypt.org/directory";
            dnsChallenge = {
              provider = "cloudflare";
              resolvers = ["1.1.1.1:53" "8.8.8.8:53"];
              propagation.delayBeforeChecks = 240;
            };
          };
        };
      };
    };

    dynamicConfigOptions = {
      http = {
        middlewares = {
          httpsRedirect = {
            redirectScheme = {
              scheme = "https";
              permanent = true;
            };
          };

          defaultHeaders = {
            headers = {
              frameDeny = true;
              browserXssFilter = true;
              contentTypeNosniff = true;
              forceSTSHeader = true;
              stsIncludeSubdomains = true;
              stsPreload = true;
              stsSeconds = 15552000;
              customFrameOptionsValue = "SAMEORIGIN";
              customRequestHeaders = {
                "X-Forwarded-Proto" = "https";
              };
            };
          };

          defaultWhitelist = {
            ipAllowList = {
              sourceRange = [ "10.25.25.0/24" ];
            };
          };

          secured = {
            chain = {
              middlewares = [
                "defaultWhitelist"
                "defaultHeaders"
              ];
            };
          };
        };


####################################################################  SERVICE REGION  ###################################################
        services = {
          coopnet = {
            loadBalancer.servers = [
              { url = "http://10.25.25.7:8096"; }
            ];
          };
          request = {
            loadBalancer.servers = [
              { url = "http://10.25.25.7:5055"; }
            ];
          };
          homepage = {
            loadBalancer.servers = [
              { url = "http://10.25.25.7:3000"; }
            ];
          };
          deluge = {
            loadBalancer.servers = [
              { url = "http://10.25.25.7:8112"; }
            ];
          };
          sonarr = {
            loadBalancer.servers = [
              { url = "http://10.25.25.7:8989"; }
            ];
          };
          radarr = {
            loadBalancer.servers = [
              { url = "http://10.25.25.7:7878"; }
            ];
          };
          prowlarr = {
            loadBalancer.servers = [
              { url = "http://10.25.25.7:9696"; }
            ];
          };
          truenas = {
            loadBalancer.servers = [
              { url = "http://10.25.25.6"; }
            ];
          };
          immich = {
            loadBalancer.servers = [
              { url = "http://10.25.25.7:2283"; }
            ];
          };
        }; # Leave me to close out SERVICE REGION


####################################################################  ROUTER REGION  ####################################################
        routers = {
          api = {
            rule = "Host(`<SERVICE.URL>`)";
            service = "api@internal";
            entrypoints = ["websecure"];
            middlewares = [ "secured" ];
            tls = {
              certResolver = "cloudflare";
            };
          };
          coopnetRouter = {
            rule = "Host(`<SERVICE.URL>`)";
            service = "coopnet";
            entrypoints = ["websecure"];
            tls = {
              certResolver = "cloudflare";
            };
          };
          requestRouter = {
            rule = "Host(`<SERVICE.URL>`)";
            service = "request";
            entrypoints = ["websecure"];
            tls = {
              certResolver = "cloudflare";
            };
          };
          immichRouter = {
            rule = "Host(`<SERVICE.URL>`)";
            service = "immich";
            entrypoints = ["websecure"];
            tls = {
              certResolver = "cloudflare";
            };
          };
          homepageRouter = {
            rule = "Host(`<SERVICE.URL>`)";
            service = "homepage";
            entrypoints = ["websecure"];
            middlewares = [ "secured" ];
            tls = {
              certResolver = "cloudflare";
            };
          };

          delugeRouter = {
            rule = "Host(`<SERVICE.URL>`)";
            service = "deluge";
            entrypoints = ["websecure"];
            middlewares = [ "secured" ];
            tls = {
              certResolver = "cloudflare";
            };
          };
          sonarrRouter = {
            rule = "Host(`<SERVICE.URL>`)";
            service = "sonarr";
            entrypoints = ["websecure"];
            middlewares = [ "secured" ];
            tls = {
              certResolver = "cloudflare";
            };
          };
          radarrRouter = {
            rule = "Host(`<SERVICE.URL>`)";
            service = "radarr";
            entrypoints = ["websecure"];
            middlewares = [ "secured" ];
            tls = {
              certResolver = "cloudflare";
            };
          };
          prowlarrRouter = {
            rule = "Host(`<SERVICE.URL>`)";
            service = "prowlarr";
            entrypoints = ["websecure"];
            middlewares = [ "secured" ];
            tls = {
              certResolver = "cloudflare";
            };
          };
          truenasRouter = {
            rule = "Host(`<SERVICE.URL>`)";
            service = "truenas";
            entrypoints = ["websecure"];
            middlewares = [ "secured" ];
            tls = {
              certResolver = "cloudflare";
            };
          };
        }; #Leave me to close out ROUTER REGION

################################################################## CLOSING REGION  #####################################################
      };
    };
  };

  system.activationScripts.traefikEnv = {
    text = ''
      echo "Creating Traefik env file..."
      cat > /var/lib/traefik/env << 'EOF'
      CF_API_EMAIL=<EMAIL>
      CF_DNS_API_TOKEN=<API>
      EOF
      chmod 600 /var/lib/traefik/env
    '';
    deps = [];
  };

  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = ["/var/lib/traefik/env"];
  };

  networking.firewall.allowedTCPPorts = [80 443];
}



#Update Certs

# Clear acme.json @ /var/lib/traefik

# Rebuild to recreate acme.json 

# Disconnect from the VPN
  # sudo systemctl stop wg-quick-wg0.service
  # sudo iptables -F
  # sudo ip6tables -F
  # sudo nmcli device connect ens18

# Aquire New Certs
  # sudo systemctl restart traefik
  # Monitor traefik w/ journalctl -u traefik -f
  # Monitor acme.json
  # Takes approx 5 min

# Reconnect > rebuild
