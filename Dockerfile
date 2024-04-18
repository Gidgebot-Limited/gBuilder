FROM debian:bullseye-slim
RUN groupadd -r gbuilder && useradd -r -g gbuilder -m gbuilder
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get update -y && \
    apt-get install -y 
RUN apt-get install -y libzip-dev 
RUN apt-get install -y libpq-dev 
RUN apt-get install -y libpng-dev 
RUN apt-get install -y curl 
RUN apt-get install -y zip 
RUN apt-get install -y git 
RUN apt-get install -y gnupg2 
RUN apt-get install -y wget 
RUN apt-get install -y lsb-release 
RUN apt-get install -y unzip   
RUN rm -rf /var/lib/apt/lists/*
RUN git config --global init.defaultBranch zero
RUN git config --global user.name gbuilder
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && apt-get install -y php8.3-cli
RUN apt-get install -y php8.3
RUN apt-get install -y php8.3-common
RUN apt-get install -y  php8.3-fpm
RUN apt-get install -y  php-json
RUN apt-get install -y php8.3-pdo
RUN apt-get install -y php8.3-mysql
RUN apt-get install -y php8.3-zip
RUN apt-get install -y php8.3-gd
RUN apt-get install -y php8.3-mbstring
RUN apt-get install -y php8.3-curl
RUN apt-get install -y php8.3-xml
RUN apt-get install -y php-pear
RUN apt-get install -y php8.3-bcmath
RUN apt-get install -y php8.3-pgsql
RUN apt-get install -y \
    php8.3-dev \
    libxml2-dev \
    libbz2-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libssl-dev
RUN apt-get update && apt-get install -y \
    php8.3-xml \
    php8.3-bcmath \
    php8.3-curl \
    php8.3-dom
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs \
    build-essential && \
    node --version && \
    npm --version
RUN apt-get install -y apache2 apache2-utils apt-utils
RUN apt-get install -y libapache2-mod-php
RUN apt-get install -y certbot
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg2 \
    ca-certificates \
    apt-transport-https \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN echo "deb [arch=amd64] https://packages.microsoft.com/debian/11/prod bullseye main" > /etc/apt/sources.list.d/microsoft.list
RUN apt-get update && \
    apt-get install -y \
    powershell \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update; \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y dotnet-sdk-6.0
RUN apt-get -y upgrade
RUN apt-get -y clean
RUN a2enmod php*
RUN a2enmod alias
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_balancer
RUN a2enmod lbmethod_byrequests
WORKDIR /etc/apache2/sites-available
RUN a2ensite *
WORKDIR /var/www/html
RUN apt-get update && \
    apt-get install -y certbot python3-certbot-apache && \
    apt-get clean
ENV LARAVEL_ENV=builder
EXPOSE 80
EXPOSE 443
CMD ["apache2ctl", "-D", "FOREGROUND", "-e", "info"]
