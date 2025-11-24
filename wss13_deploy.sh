#!/bin/bash

set -e

echo "============================================"
echo " 🚀 DEPLOY WSS+13 — Plataforma AI"
echo "============================================"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Corrigir .env
echo "▶️  Corrigindo .env..."
bash wss13_fix_env.sh

# 2. Build das imagens
echo "▶️  Construindo containers..."
docker-compose build --no-cache

# 3. Subir containers
echo "▶️  Iniciando containers..."
docker-compose up -d

# 4. Aguardar services ficarem prontos
echo "▶️  Aguardando serviços iniciarem..."
sleep 5

# 5. Verificar status
echo "▶️  Verificando serviços..."
docker-compose ps

# 6. Verificar saúde da API
echo "▶️  Testando conectividade da API..."
for i in {1..30}; do
  if curl -s http://localhost:3001/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ API está respondendo!${NC}"
    break
  fi
  if [ $i -eq 30 ]; then
    echo -e "${RED}❌ API não respondeu após 30 tentativas${NC}"
    exit 1
  fi
  echo "Tentativa $i/30..."
  sleep 1
done

echo ""
echo "============================================"
echo -e "${GREEN}✅ Deploy realizado com sucesso!${NC}"
echo "============================================"
echo ""
echo "🌐 Acesse a plataforma:"
echo "   Local: http://localhost:3001"
echo "   Nginx: http://localhost"
echo ""
echo "📊 Comandos úteis:"
echo "   Ver logs:     docker-compose logs -f api"
echo "   Parar tudo:   docker-compose down"
echo "   Reiniciar:    docker-compose restart"
echo ""
