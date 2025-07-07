
# Empacotamento com Docker Compose – FiveWhysMaintenance

## Pré-requisitos

- Docker
- Docker Compose

## Estrutura

- `backend/`: API FastAPI com banco SQLite
- `frontend/`: App Flutter Web
- `docker-compose.yml`: orquestra os dois serviços

## Instruções

```bash
docker compose up --build
```

- Acesse o **frontend** via: http://localhost:8080
- A API (caso teste externo) está em: http://localhost:8001/analisar

## Observação sobre o APK

O APK pode ser gerado via:

```bash
cd frontend
flutter build apk --release
```

O resultado estará em:

```
build/app/outputs/flutter-apk/app-release.apk
```

Este APK de teste funcionará em dispositivos Android, desde que a permissão de instalação de fontes desconhecidas esteja habilitada.
