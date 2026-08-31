#!/bin/bash

# 1. Enrutamiento estricto hacia el Gateway de Tor preservando la red local
ip route del default 2>/dev/null
ip route add default via 192.168.20.10

# 2. Inyección de Enterprise Policies (Sintaxis oficial Firefox)
mkdir -p /etc/firefox/policies
mkdir -p /usr/lib/firefox/distribution
mkdir -p /usr/lib/firefox-esr/distribution

cat <<'EOF' > /tmp/policies.json
{
  "policies": {
    "DisableAppUpdate": true,
    "OverrideFirstRunPage": "",
    "OverridePostUpdatePage": "",
    "DontCheckDefaultBrowser": true,
    "DisplayBookmarksToolbar": "always",
    "Homepage": {
      "URL": "https://ahmia.fi",
      "Locked": false,
      "StartPage": "homepage"
    },
    "Bookmarks": [
      {
        "Title": "Ahmia.fi (Buscador Onion)",
        "URL": "https://ahmia.fi",
        "Placement": "toolbar"
      },
      {
        "Title": "Ransomlooker (Monitor Ransomware)",
        "URL": "https://www.ransomlooker.net",
        "Placement": "toolbar"
      },
      {
        "Title": "Blockchain Explorer",
        "URL": "https://www.blockchain.com/explorer",
        "Placement": "toolbar"
      },
      {
        "Title": "Etherscan",
        "URL": "https://etherscan.io",
        "Placement": "toolbar"
      },
      {
        "Title": "Have I Been Pwned",
        "URL": "https://haveibeenpwned.com",
        "Placement": "toolbar"
      },
      {
        "Title": "Intelligence X",
        "URL": "https://intelx.io",
        "Placement": "toolbar"
      },
      {
        "Title": "Epieos OSINT",
        "URL": "https://epieos.com",
        "Placement": "toolbar"
      }
    ]
  }
}
EOF

cp /tmp/policies.json /etc/firefox/policies/policies.json
cp /tmp/policies.json /usr/lib/firefox/distribution/policies.json
cp /tmp/policies.json /usr/lib/firefox-esr/distribution/policies.json

# 3. Configurar Display virtual X11
export DISPLAY=:1
Xvfb :1 -screen 0 1280x1024x24 &
sleep 2

# 4. Iniciar sesión XFCE usando D-Bus
dbus-launch --exit-with-session xfce4-session &
sleep 2

# 5. Iniciar servidor VNC en localhost:5900
x11vnc -display :1 -forever -nopw -shared -rfbport 5900 -listen 127.0.0.1 &
sleep 2

# 6. Iniciar websockify escuchando explícitamente en 0.0.0.0
websockify --web /usr/share/novnc/ 0.0.0.0:8080 127.0.0.1:5900 &

# Mantener el contenedor activo
tail -f /dev/null