# gateway/Dockerfile
FROM debian:12-slim

RUN apt-get update && apt-get install -y tor iptables iproute2 && rm -rf /var/lib/apt/lists/*

# Configuración básica de Tor
RUN echo "VirtualAddrNetworkIPv4 10.192.0.0/10\nAutomapHostsOnResolve 1\nTransPort 0.0.0.0:9040\nDNSPort 0.0.0.0:5353" > /etc/tor/torrc

# Script de entrada para redirigir el tráfico saliente de la Workstation hacia Tor
RUN echo '#!/bin/sh\n\
sysctl -w net.ipv4.ip_forward=1\n\
iptables -t nat -A PREROUTING -i eth1 -p udp --dport 53 -j REDIRECT --to-ports 5353\n\
iptables -t nat -A PREROUTING -i eth1 -p tcp --syn -j REDIRECT --to-ports 9040\n\
exec tor\n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]