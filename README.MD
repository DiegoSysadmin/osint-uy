# OSINT-UY

![LOGO](/images/LOGO.jpg)


🚓 Investigar cibercrimen en fuentes abiertas (OSINT) exige un equilibrio crítico entre recolección de inteligencia y seguridad operacional (OpSec). Durante años, la comunidad dependió de distribuciones monolíticas en máquinas virtuales que hoy están abandonadas o rotas por el clásico dependency drift. Esta solución basada en microservicios con Docker Compose que desacopla la navegación anónima del análisis, garantizando cero fugas de IP (DNS/IP leaks) y un despliegue en segundos.

#### Aislamiento Tipo Whonix en Docker
El sistema se divide en dos niveles lógicos interconectados por una subred interna privada (192.168.20.0/24):
* **osint-gateway (Proxy Transparente)**: Un contenedor basado en Debian con iptables y Tor configurado con TransPort 9040 y DNSPort 5353. Captura cualquier petición TCP/UDP saliente de la subred interna y la canaliza obligatoriamente por la red Tor.
* **osint-workstation (Estación de Análisis)**: Un contenedor Ubuntu que contiene el arsenal de herramientas y carece de ruta por defecto directa a Internet. Su única salida es la IP interna del Gateway (192.168.20.10).

```Text
[Analista / Host] ──(HTTP :8080)──► [osint-workstation] ──(Red Aislada)──► [osint-gateway / Tor] ──► Internet
```
# Requisitos previos

## Instalar Git

### Comandos de instalación por distribución

```text
# Ubuntu / Debian:
sudo apt update && sudo apt install git
```
```text
# Fedora:
sudo dnf install git (o sudo yum install git en versiones previas)
```
```text
# Arch Linux:
sudo pacman -S git
```

## Instalar Docker
Para instalar Docker se sugiere ir directamente a la web oficial y consultar la instalación para el Sistema Operativo que corresponda. En esta seccion se presenta como ejemplo la instalación para CentOS (Rocky/Fedora) y Ubuntu Linux.

[Web oficial](https://docs.docker.com/engine/install/)

```text
# Rocky
# Desinstalar versiones viejas:
sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

```text
# Ubuntu
# Desinstalar versiones viejas:
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc | cut -f1)
```

NOTA: Si no hay instalaciones previas es normal que no encuentre nada para desinstalar.

### Instalar desde repositorio usando rpm - Rocky

```text
# Configurar repositorio:
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
```text
# Instalar Docker Engine:
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
```text
# Arrancar Docker Engine:
sudo systemctl enable --now docker
```
```text
# Verificar instalación:
sudo docker run hello-world
```

### Instalar desde repositorio usando apt - Ubuntu

```text
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
```
```text
# Instalar el paquete Docker
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
```text
# Verificar que Docker está corriendo
sudo systemctl status docker
```
```text
Si no esta corriendo arrancarlo manualmente
sudo systemctl start docker
```
```text
# Verificar instalación:
sudo docker run hello-world
```

# Instalación

## 1. Clonar el repositorio del TFM

```text
git clone https://github.com/DiegoSysadmin/osint-uy.git
cd osint-uy
chmod +x workstation/entrypoint.sh
```

## 2. Desplegar la infraestructura
```text
docker compose up --build -d
```

## 3. Acceder al entorno seguro de investigación

El analista abre su navegador local e ingresa a: http://localhost:8080/vnc.html

## 4. Actualizar los contenedoresceder al entorno seguro de investigación

```text
Pararse dentro de la carpeta del repositorio de git descargado:
cd /tu_ruta_al_repo/osintuy

# Detener los contenedores previos
docker compose down

# Descargar la imagen recién subida
docker compose pull

# Iniciar nuevamente
docker compose up -d
```