# Dockerfile.backend
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Ensure environment variables are available
COPY .env ./

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]
