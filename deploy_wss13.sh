#!/bin/bash

echo "=============================================="
echo " 🚀 WSS+13 — Script oficial de deploy"
echo " Criador: Marcos Sea (👨🏾‍💻)"
echo " Fundação: 1.01.01 → 001101₂ → 13₁₀"
echo "=============================================="
echo ""

# Criar Dockerfile
cat > Dockerfile << 'EOF'
FROM node:18

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

EXPOSE 3000
CMD ["npm", "start"]
EOF

# Criar docker-compose.yaml
cat > docker-compose.yaml << 'EOF'
version: "3.9"

services:
  api:
    container_name: wss13_api
    build: .
    restart: always
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://postgres:wss13@db:5432/wss13
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:15
    container_name: wss13_db
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: wss13
      POSTGRES_DB: wss13
    volumes:
      - ./pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7
    container_name: wss13_redis
    restart: always
    ports:
      - "6379:6379"

  nginx:
    image: nginx:alpine
    container_name: wss13_nginx
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./certbot:/etc/letsencrypt
    depends_on:
      - api

networks:
  default:
    name: wss13_network
EOF

# Criar nginx.conf
cat > nginx.conf << 'EOF'
events {}

http {
    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://api:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
EOF

# Criar pastas necessárias
mkdir -p pgdata certbot

# Iniciar containers
echo ""
echo "📦 Subindo containers..."
docker-compose up -d

echo ""
echo "=============================================="
echo " ✅ Deploy WSS+13 AI Platform finalizado!"
echo " Acesse via: http://localhost:3000"
echo "=============================================="
