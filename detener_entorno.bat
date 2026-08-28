@echo off
TITLE Detener Entorno OSINT Policial
echo [-] Deteniendo infraestructura OSINT...
docker compose down
echo [OK] Entorno detenido correctamente.
pause