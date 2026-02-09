# Usa a imagem oficial do PHP com Apache
FROM php:8.2-apache

# 1. Instala dependências do sistema (zip, git, etc)
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    libpng-dev \
    libonig-dev \
    libxml2-dev

# 2. Limpa o cache do apt para diminuir o tamanho da imagem
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Instala extensões do PHP necessárias para o Laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# 4. Habilita o mod_rewrite do Apache (essencial para rotas do Laravel!)
RUN a2enmod rewrite

# 5. Define a pasta de trabalho
WORKDIR /var/www/html

# 6. Instala o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 7. Copia os arquivos do projeto para dentro do container
COPY . /var/www/html

# 8. Instala dependências do Laravel (Otimizado para produção)
RUN composer install --no-dev --optimize-autoloader

# 9. Configura permissões (O Apache precisa ser dono dos arquivos)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 10. Ajusta o Apache para apontar para a pasta /public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf \ /etc/apache2/conf-available/*.conf

# 11. Define a porta que o Render usa (O Render injeta a variável PORT)
# Vamos usar um script de entrada para configurar isso na hora de rodar
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 12. Comando final
ENTRYPOINT ["docker-entrypoint.sh"]