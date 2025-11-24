#!/bin/bash

set -e

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🔧 Corrigindo .env para Docker WSS+13...${NC}"

# Se não existe .env, criar from .env.example ou criar padrão
if [ ! -f .env ]; then
  echo "Criando .env padrão..."
  cat > .env << 'EOF'
# ============ BACKEND ============
NODE_ENV=development
PORT=3000
APP_URL=http://localhost:3000

# ============ DATABASE ============
DATABASE_URL=postgresql://wss13_user:euemas12@wss13_db:5432/wss13
DB_HOST=wss13_db
DB_PORT=5432
DB_USER=wss13_user
DB_PASSWORD=euemas12
DB_NAME=wss13

# ============ REDIS ============
REDIS_URL=redis://wss13_redis:6379
REDIS_HOST=wss13_redis
REDIS_PORT=6379

# ============ JWT ============
JWT_SECRET=seu_secret_jwt_super_seguro_aqui_mude_em_producao
JWT_EXPIRES_IN=7d

# ============ EMAIL ============
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=seu_email@gmail.com
SMTP_PASSWORD=sua_senha_app_aqui
EMAIL_FROM=noreply@wss13.com.br

# ============ AWS (opcional) ============
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=sua_chave_aqui
AWS_SECRET_ACCESS_KEY=sua_secret_aqui

# ============ N8N ============
N8N_URL=http://n8n:5678
N8N_WEBHOOK_URL=http://wss13_api:3000/webhooks

# ============ LOGGING ============
LOG_LEVEL=debug
LOG_FORMAT=json

# ============ SECURITY ============
CORS_ORIGIN=http://localhost:3000,http://localhost:5173
RATE_LIMIT_WINDOW=15m
RATE_LIMIT_MAX_REQUESTS=100

# ============ FEATURES ============
ENABLE_2FA=true
ENABLE_OAUTH=false
ENABLE_ANALYTICS=true
EOF
  echo -e "${GREEN}✅ .env criado com sucesso!${NC}"
else
  echo ".env já existe, validando..."
fi

# Validar e corrigir URLs de banco de dados
if ! grep -q "DATABASE_URL=postgresql://.*wss13_db" .env; then
  echo "Corrigindo DATABASE_URL..."
  sed -i 's|DATABASE_URL=.*|DATABASE_URL=postgresql://wss13_user:euemas12@wss13_db:5432/wss13|g' .env
fi

# Validar e corrigir Redis URL
if ! grep -q "REDIS_URL=redis://wss13_redis" .env; then
  echo "Corrigindo REDIS_URL..."
  sed -i 's|REDIS_URL=.*|REDIS_URL=redis://wss13_redis:6379|g' .env
fi

# Validar NODE_ENV
if ! grep -q "NODE_ENV=" .env; then
  echo "Adicionando NODE_ENV..."
  echo "NODE_ENV=development" >> .env
fi

echo -e "${GREEN}✅ .env corrigido com sucesso!${NC}"
echo ""
echo "📋 Variáveis críticas:"
echo "   DATABASE_URL: postgresql://wss13_user:euemas12@wss13_db:5432/wss13"
echo "   REDIS_URL: redis://wss13_redis:6379"
echo "   NODE_ENV: development"
echo ""
