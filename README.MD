# 0. Pasos previos

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
## El analista abre su navegador local e ingresa a: http://localhost:8080/vnc.html

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