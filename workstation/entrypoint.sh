#!/bin/bash

# 1. Enrutamiento estricto hacia el Gateway de Tor
ip route del default 2>/dev/null
ip route add default via 192.168.20.10

# 2. Copiar marcadores al perfil de Firefox (si no existen)
mkdir -p /root/.mozilla/firefox/osint.default-release
cat <<EOF > /root/.mozilla/firefox/osint.default-release/bookmarks.html
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<TITLE>Marcadores OSINT Policial</TITLE>
<H1>Marcadores</H1>
<DL><p>
    <DT><H3>🌐 CIBERCRIMEN & DARK WEB</H3>
    <DL><p>
        <DT><A HREF="https://ahmia.fi">Ahmia.fi - Buscador Onion</A>
        <DT><A HREF="https://www.ransomlooker.net">Ransomlooker - Monitoreo Ransomware</A>
    </DL><p>
</DL><p>
EOF

# 3. Levantar entorno gráfico en memoria (Xvfb + XFCE + VNC + noVNC)
Xvfb :1 -screen 0 1280x1024x24 &
export DISPLAY=:1
sleep 1

xfce4-session &
x11vnc -forever -nopw -listen localhost -display :1 &
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 8080 &

# Mantener el contenedor activo
tail -f /dev/null