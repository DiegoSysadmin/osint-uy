@echo off
TITLE Despliegue Entorno OSINT Policial - Docker Windows
echo =======================================================
echo    INICIANDO LABORATORIO OSINT POLICIAL (DOCKER/WSL2)
echo =======================================================
echo.

REM 1. Verificar si Docker Desktop esta corriendo
docker info >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [X] ERROR: Docker Desktop no se encuentra en ejecucion.
    echo     Por favor inicia Docker Desktop en Windows y reintenta.
    pause
    exit /b
)

echo [-] Descargando ultimas imagenes desde Docker Hub...
docker compose pull

echo [-] Levantando contenedores (Gateway + Workstation)...
docker compose up -d

echo.
echo =======================================================
echo [OK] Entorno desplegado con exito.
echo [-] Abriendo estacion de trabajo en el navegador...
echo =======================================================

REM 2. Abrir automaticamente el navegador predeterminado de Windows en noVNC
timeout /t 3 >nul
start http://localhost:8080/vnc.html

echo.
echo Presiona cualquier tecla para detener el entorno cuando finalices...
pause >nul

echo [-] Deteniendo contenedores...
docker compose down
echo [OK] Laboratorio apagado limpiamente.
pause