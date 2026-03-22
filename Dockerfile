# ============================================
# Dockerfile - DVWA
# ============================================

# Image de base PHP + Apache
FROM php:8.1-apache

# Installer les extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copier le code DVWA
COPY . /var/www/html/

# Configuration Apache pour permettre .htaccess
RUN a2enmod rewrite && \
    sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Health check pour vérifier que l'app est prête
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Exposer le port 80
EXPOSE 80

# Démarrer Apache en foreground
CMD ["apache2-foreground"]
