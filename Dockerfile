FROM docker.io/phpswoole/swoole:php8.3-alpine

WORKDIR /app

RUN apk add --no-cache \
    # ffmpeg for video encoding
    ffmpeg \
    # extra utils
    vim \
    curl \
    bash \
    # php extension dependencies \
    libzip-dev \
    icu-dev \
    $PHPIZE_DEPS

# had to install imagemagick from alpine repos since pecl install was failing
RUN apk add --no-cache imagemagick-dev imagemagick php83-pecl-imagick && \
    ln -s /usr/lib/php83/modules/imagick.so /usr/local/lib/php/extensions/no-debug-non-zts-20230831/imagick.so && \
    docker-php-ext-enable imagick

# install PHP extensions
RUN docker-php-ext-install \
    zip \
    pcntl \
    intl \
    && \
    docker-php-ext-enable zip pcntl intl

# remove build dependencies
RUN apk del $PHPIZE_DEPS

# install cronn the better cron alternative
RUN wget "https://github.com/umputun/cronn/releases/download/v1.1.0/cronn_v1.1.0_linux_x86_64.tar.gz" && \
    tar -xzf cronn_v1.1.0_linux_x86_64.tar.gz && \
    mv cronn /usr/local/bin/cronn && \
    rm cronn_v1.1.0_linux_x86_64.tar.gz