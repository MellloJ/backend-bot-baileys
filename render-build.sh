#!/usr/bin/env bash
# Se der erro em qualquer linha, para tudo
set -o errexit

# 1. Instalar dependências do PHP
composer install --no-dev --optimize-autoloader

# 2. Compilar os assets (CSS/JS) se você usa Vite/Tailwind
npm install
npm run build

# 3. Limpar e criar cache de configuração (Crucial para produção)
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 4. Rodar as migrações no banco do Aiven (automático!)
php artisan migrate --force