#!/bin/bash
set -e

# Configura a porta do Apache para bater com a do Render
sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# Roda comandos do Laravel
echo "🔥 Rodando cache de config..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "🚀 Rodando migrações..."
php artisan migrate --force

# Inicia o Apache em primeiro plano
echo "🌍 Iniciando Apache..."
apache2-foreground