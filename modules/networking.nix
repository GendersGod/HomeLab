# scp -q /home/nick/Documents/VScodium/CoopNetConf/networking.nix nick@10.25.25.7:/home/nick/modules

{ config, lib, pkgs, ... }: {

### NETWORKING ###
  networking = {
    firewall.allowedTCPPorts = [ 80 443 2049 ];
    networkmanager.enable = true;
    wireguard.enable = true;
    useDHCP = false;

    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "10.25.25.7";
        prefixLength = 24;
      }];
    };
    defaultGateway = "10.25.25.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

### VPN ###
  networking.firewall = {
    allowedUDPPorts = [
      config.networking.wg-quick.interfaces.wg0.listenPort
      53
      ];
  };
  networking.wg-quick.interfaces = let
    server_ip = "<IP>"; # =Conf Endpoint
  in {
    wg0 = {
      # IP address of this machine in the *tunnel network*
      address = [
        "<IP>"
        "<IP>"
      ];
      listenPort = 51820; # =Conf Endpoint Port
      privateKeyFile = "/etc/mullvad-vpn.key";
      peers = [{
        publicKey = "<KEY>";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "${server_ip}:51820";
        persistentKeepalive = 25;
      }];
      
#### IPTABLE KILLSWITCH ###
      postUp = ''
        wg set wg0 fwmark 51820
      
        # allow VPN subnet communication
        ${pkgs.iptables}/bin/iptables -I OUTPUT -s 10.25.25.7 -d 10.25.25.0/24 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -I INPUT  -s 10.25.25.0/24 -d 10.25.25.7 -j ACCEPT
      
        # allow inbound HTTP/HTTPS from the internet
        ${pkgs.iptables}/bin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -I INPUT -p tcp --dport 443 -j ACCEPT
      
        # allow outbound responses to established connections (for Traefik replies)
        ${pkgs.iptables}/bin/iptables -I OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      
        # killswitch: block everything else not going through wg0
        ${pkgs.iptables}/bin/iptables -A OUTPUT \
          ! -d 192.168.0.0/16 \
          ! -o wg0 \
          -m mark ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
      
        ${pkgs.iptables}/bin/ip6tables -A OUTPUT \
          ! -o wg0 \
          -m mark ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
      '';
      
      postDown = ''
        ${pkgs.iptables}/bin/iptables -D OUTPUT -s 10.25.25.7 -d 10.25.25.0/24 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -D INPUT  -s 10.25.25.0/24 -d 10.25.25.7 -j ACCEPT
      
        ${pkgs.iptables}/bin/iptables -D INPUT -p tcp --dport 80 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -D INPUT -p tcp --dport 443 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -D OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      
        ${pkgs.iptables}/bin/iptables -D OUTPUT \
          ! -o wg0 \
          -m mark ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
      
        ${pkgs.iptables}/bin/ip6tables -D OUTPUT \
          ! -o wg0 -m mark \
          ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
      '';
    };
  };
}
