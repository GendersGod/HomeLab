HomeLab

     Traefik Reverse Proxy/Cloudlfare
     Jellyfin
     Homepage
     Sonarr
     Radarr
     Prowlarr
     Flaresolverr
     Jellyseer
     Immich
     Deluge
     
Traefik Update Certificates

    1. Stop traefik > sudo systemctl stop traefik
    2. Delete acme.json @ /var/lib/traefik (you'll need to sudo -s into the traefik directory)
    3. Rebuild to recreate acme.json
    4. Disconnect and Restart Traefik
        sudo systemctl stop wg-quick-wg0.service && \
        sudo iptables -F && \
        sudo ip6tables -F && \
        sudo nmcli device connect ens18 && \
        sudo systemctl restart traefik && \
        journalctl -u traefik -f
    5. Monitor for failure logs and cat acme.json to confirm certs. Takes around 5 min.
    6. Rebuild to reconnect to the vpn


Disconnect from WG VPN

    1. Copy/Pasta
        sudo systemctl stop wg-quick-wg0.service && \
        sudo iptables -F && \
        sudo ip6tables -F && \
        sudo nmcli device connect ens18
    2. Reconnect > rebuild
