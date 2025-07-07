
@echo off
cd /d "%~dp0"
echo Iniciando FiveWhysMaintenance com BuildKit desativado...
docker compose up --build
pause
