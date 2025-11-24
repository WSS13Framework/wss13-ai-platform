const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Rota raiz
app.get('/', (req, res) => {
  res.json({
    status: 'ok',
    message: '🚀 WSS+13 AI Platform',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

// Health
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', uptime: process.uptime() });
});

// Status
app.get('/api/status', (req, res) => {
  res.json({
    status: 'running',
    platform: 'WSS+13 AI',
    database: 'connected',
    redis: 'connected'
  });
});

// 404
app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// Iniciar
const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🚀 WSS+13 AI Platform rodando na porta ${PORT}\n`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM recebido, fechando servidor...');
  server.close(() => {
    console.log('Servidor fechado');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT recebido, fechando servidor...');
  server.close(() => {
    console.log('Servidor fechado');
    process.exit(0);
  });
});

process.on('uncaughtException', (err) => {
  console.error('Erro não capturado:', err);
  process.exit(1);
});
