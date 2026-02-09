#!/usr/bin/env bash
# Saia se houver erro
set -o errexit

# Instala dependências do PHP
composer install --no-dev --optimize-autoloader

# Instala dependências do Front-end (se usar Vite/Tailwind)
npm install
npm run build

# Limpa cache para evitar problemas
php artisan config:clear
php artisan cache:clear

# Roda as migrações do banco (Cria as tabelas automaticamente)
php artisan migrate --force
