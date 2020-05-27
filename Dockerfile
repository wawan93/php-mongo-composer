FROM php:fpm-alpine

# Install dev dependencies
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    curl-dev \
    imagemagick-dev \
    libtool \
    libxml2-dev


# Install production dependencies
RUN apk add --no-cache \
    bash \
    git \
    curl \
    gmp-dev \
    imagemagick \
    libpng-dev \
    mysql-client \
    nodejs \
    nodejs-npm \
    yarn \
    openssh-client \
    zlib-dev \
    libzip-dev \
    oniguruma-dev

# Install PECL and PEAR extensions
RUN pecl install \
    imagick \
    redis \
    mongodb

# Install and enable php extensions
RUN docker-php-ext-enable \
    imagick \
    redis \
    mongodb
RUN docker-php-ext-configure zip
RUN docker-php-ext-install \
    curl \
    iconv \
    mbstring \
    pdo \
    pdo_mysql \
    pcntl \
    tokenizer \
    xml \
    gd \
    gmp \
    zip \
    bcmath

# Install composer
ENV COMPOSER_HOME /composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Cleanup dev dependencies
RUN apk del -f .build-deps

