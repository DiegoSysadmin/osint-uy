# OSINT-UY

██████╗ ███████╗██╗███╗   ██╗████████╗    ██╗   ██╗██╗   ██╗
 ██╔═══██╗██╔════╝██║████╗  ██║╚══██╔══╝    ██║   ██║╚██╗ ██╔╝
 ██║   ██║███████╗██║██╔██╗ ██║   ██║ █████╗██║   ██║ ╚████╔╝ 
 ██║   ██║╚════██║██║██║╚██╗██║   ██║ ╚════╝██║   ██║  ╚██╔╝  
 ╚██████╔╝███████║██║██║ ╚████║   ██║       ╚██████╔╝   ██║   
  ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝   ╚═╝        ╚═════╝    ╚═╝   
    [ OSINT Police Investigation Environment - Uruguay ]

Investigar cibercrimen en fuentes abiertas (OSINT) exige un equilibrio crítico entre recolección de inteligencia y seguridad operacional (OpSec).
Durante años, la comunidad dependió de distribuciones monolíticas en máquinas virtuales que hoy están abandonadas o rotas por el clásico dependency drift.
Diseñamos una solución basada en microservicios con Docker Compose que desacopla la navegación anónima del análisis, garantizando cero fugas de IP (DNS/IP leaks) y un despliegue en segundos.

Aislamiento Tipo Whonix en Docker
El sistema se divide en dos niveles lógicos interconectados por una subred interna privada (192.168.20.0/24):
•	osint-gateway (Proxy Transparente): Un contenedor basado en Debian con iptables y Tor configurado con TransPort 9040 y DNSPort 5353. Captura cualquier petición TCP/UDP saliente de la subred interna y la canaliza obligatoriamente por la red Tor.
•	osint-workstation (Estación de Análisis): Un contenedor Ubuntu que contiene el arsenal de herramientas y carece de ruta por defecto directa a Internet. Su única salida es la IP interna del Gateway (192.168.20.10).

Plaintext
[Analista / Host] ──(HTTP :8080)──► [osint-workstation] ──(Red Aislada)──► [osint-gateway / Tor] ──► Internet

Retos de Ingeniería y Empaquetado Moderno
Convertir herramientas clásicas a un entorno contenerizado reproducible requirió resolver tres obstáculos técnicos:
1.	Migración a pyproject.toml: Utilidades como Sherlock y theHarvester abandonaron los viejos requirements.txt. El aprovisionamiento se adaptó para compilar paquetes modernos directamente con pip install ..
2.	Micro-entornos Virtuales Aislados: Cada herramienta se encapsuló en su propio venv dentro de /opt/osint_policial/herramientas/, exponiendo binarios globales a /usr/local/bin/ para erradicar conflictos de dependencias cruzadas.
3.	Escritorio Web Ligero (Headless GUI): Mediante la pila Xvfb + XFCE4 + x11vnc + websockify/noVNC, el analista accede a la interfaz gráfica completa y al navegador Firefox con marcadores policiales preconfigurados desde cualquier navegador anfitrión en http://localhost:8080/vnc.html.
Despliegue en 3 Pasos
Gracias a las imágenes publicadas en Docker Hub, el entorno no requiere compilación local:
Bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/tfm-osint-policial.git && cd tfm-osint-policial

# 2. Levantar la infraestructura
docker compose up -d

# 3. Acceder al laboratorio
# Abrir en el navegador: http://localhost:8080/vnc.html
Este enfoque ofrece una alternativa ligera (~1.8 GB frente a los 20 GB de una VM tradicional), modular y estrictamente anonimizada para analistas de ciberinteligencia y unidades de persecución del delito informático.





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