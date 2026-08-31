#!/bin/bash

# 1. Enrutamiento estricto hacia el Gateway de Tor preservando la red local
ip route del default 2>/dev/null
ip route add default via 192.168.20.10

# 2. Configurar Display virtual X11
export DISPLAY=:1
Xvfb :1 -screen 0 1280x1024x24 &
sleep 2

# 3. Iniciar sesión XFCE usando D-Bus
dbus-launch --exit-with-session xfce4-session &
sleep 2

# 4. Iniciar servidor VNC en localhost:5900
x11vnc -display :1 -forever -nopw -shared -rfbport 5900 -listen 127.0.0.1 &
sleep 2

# 5. Iniciar websockify escuchando explícitamente en 0.0.0.0
websockify --web /usr/share/novnc/ 0.0.0.0:8080 127.0.0.1:5900 &

# Mantener el contenedor activo
tail -f /dev/null