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
    bash

# create symlinks for extensions installed from alpine repos
RUN ln -s /usr/lib/php83/modules/imagick.so /usr/local/lib/php/extensions/no-debug-non-zts-20230831/ && \
    echo "extension=imagick.so" > /usr/local/etc/php/conf.d/imagick.ini

RUN wget "https://github.com/umputun/cronn/releases/download/v1.1.0/cronn_v1.1.0_linux_x86_64.tar.gz" && \
    tar -xzf cronn_v1.1.0_linux_x86_64.tar.gz && \
    mv cronn /usr/local/bin/cronn && \
    rm cronn_v1.1.0_linux_x86_64.tar.gz