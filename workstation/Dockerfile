FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Entorno Gráfico, noVNC y herramientas del sistema
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies xvfb x11vnc novnc firefox cherrytree \
    git python3 python3-venv python3-pip tor nmap whois \
    libxml2-dev libxslt1-dev build-essential curl wget tmux \
    && rm -rf /var/lib/apt/lists/*

# 2. Estructura de herramientas OSINT
RUN mkdir -p /opt/osint_policial/herramientas

# Sherlock
RUN cd /opt/osint_policial/herramientas && \
    git clone https://github.com/sherlock-project/sherlock.git && \
    cd sherlock && python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install . && \
    ln -sf /opt/osint_policial/herramientas/sherlock/venv/bin/sherlock /usr/local/bin/sherlock

# Holehe
RUN mkdir -p /opt/osint_policial/herramientas/holehe && \
    cd /opt/osint_policial/herramientas/holehe && \
    python3 -m venv venv && \
    ./venv/bin/pip install holehe && \
    ln -sf /opt/osint_policial/herramientas/holehe/venv/bin/holehe /usr/local/bin/holehe

# Spiderfoot
RUN cd /opt/osint_policial/herramientas && \
    git clone https://github.com/smicallef/spiderfoot.git && \
    cd spiderfoot && python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install "lxml>=5.3.0" && \
    ./venv/bin/pip install -r requirements.txt

# theHarvester
RUN cd /opt/osint_policial/herramientas && \
    git clone https://github.com/laramies/theHarvester.git && \
    cd theHarvester && python3 -m venv venv && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install . && \
    ln -sf /opt/osint_policial/herramientas/theHarvester/venv/bin/theHarvester /usr/local/bin/theHarvester

# OnionSearch
RUN mkdir -p /opt/osint_policial/herramientas/onionsearch && \
    cd /opt/osint_policial/herramientas/onionsearch && \
    python3 -m venv venv && \
    ./venv/bin/pip install onionsearch && \
    ln -sf /opt/osint_policial/herramientas/onionsearch/venv/bin/onionsearch /usr/local/bin/onionsearch

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]