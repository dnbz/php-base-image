FROM docker.io/phpswoole/swoole:php8.3-alpine

WORKDIR /app

RUN apk add --no-cache \
    php83-pecl-imagick \
    php83-intl \
    php83-pcntl \
    # ffmpeg for video encoding
    ffmpeg \
    # extra utils
    vim \
    curl \
    bash \
    # php extension dependencies \
    libzip-dev

# install PHP extensions
RUN docker-php-ext-install \
    zip && \
    docker-php-ext-enable zip

# create symlinks for extensions installed from alpine repos
RUN ln -s /usr/lib/php83/modules/imagick.so /usr/local/lib/php/extensions/no-debug-non-zts-20230831/ && \
    ln -s /usr/lib/php83/modules/intl.so /usr/local/lib/php/extensions/no-debug-non-zts-20230831/ && \
    ln -s /usr/lib/php83/modules/pcntl.so /usr/local/lib/php/extensions/no-debug-non-zts-20230831/ && \
    echo "extension=imagick.so" > /usr/local/etc/php/conf.d/imagick.ini && \
    echo "extension=intl.so" > /usr/local/etc/php/conf.d/intl.ini && \
    echo "extension=pcntl.so" > /usr/local/etc/php/conf.d/pcntl.ini

RUN wget "https://github.com/umputun/cronn/releases/download/v1.1.0/cronn_v1.1.0_linux_x86_64.tar.gz" && \
    tar -xzf cronn_v1.1.0_linux_x86_64.tar.gz && \
    mv cronn /usr/local/bin/cronn && \
    rm cronn_v1.1.0_linux_x86_64.tar.gz