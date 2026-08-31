# OSINT-UY

![LOGO](/images/LOGO.jpg)


🚓 Investigar cibercrimen en fuentes abiertas (OSINT) exige un equilibrio crítico entre recolección de inteligencia y seguridad operacional (OpSec). Durante años, la comunidad dependió de distribuciones monolíticas en máquinas virtuales que hoy están abandonadas o rotas por el clásico dependency drift. Esta solución basada en microservicios con Docker Compose que desacopla la navegación anónima del análisis, garantizando cero fugas de IP (DNS/IP leaks) y un despliegue en segundos.

**Aislamiento Tipo Whonix en Docker**
El sistema se divide en dos niveles lógicos interconectados por una subred interna privada (192.168.20.0/24):
* **osint-gateway (Proxy Transparente)**: Un contenedor basado en Debian con iptables y Tor configurado con TransPort 9040 y DNSPort 5353. Captura cualquier petición TCP/UDP saliente de la subred interna y la canaliza obligatoriamente por la red Tor.
* **osint-workstation (Estación de Análisis)**: Un contenedor Ubuntu que contiene el arsenal de herramientas y carece de ruta por defecto directa a Internet. Su única salida es la IP interna del Gateway (192.168.20.10).

Plaintext
[Analista / Host] ──(HTTP :8080)──► [osint-workstation] ──(Red Aislada)──► [osint-gateway / Tor] ──► Internet

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
Para instalar Docker se sugiere ir directamente a la web oficial y consultar la instalación para el Sistema Operativo que corresponda. En esta seccion se presenta como ejemplo la instalación para CentOS (Rocky) Linux.

[Web oficial](https://docs.docker.com/engine/install/)

```text
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

NOTA: Si no hay instalaciones previas es normal que no encuentre nada para desinstalar.

### Instalar desde repositorio usando rpm

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


# 1. Clonar el repositorio del TFM
```text
git clone https://github.com/osintuy.git
cd osintuy
```

# 2. Desplegar la infraestructura
```text
docker compose up --build -d
```

# 3. Acceder al entorno seguro de investigación

El analista abre su navegador local e ingresa a: http://localhost:8080/vnc.html

# 4. Actualizar los contenedoresceder al entorno seguro de investigación

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