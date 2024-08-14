FROM docker.io/openswoole/swoole:php8.3-alpine

# variable for holding dev dependencies
ARG DEV_DEPENDENCIES="curl-dev pcre-dev libpng-dev libjpeg-turbo-dev freetype-dev libxslt-dev gettext-dev icu-dev libzip-dev zip libxml2-dev postgresql-dev sqlite-dev libmcrypt-dev libmemcached-dev libssh-dev gettext autoconf cmake make gcc g++ tzdata musl-dev libc-dev"

WORKDIR /app

RUN apk add --no-cache \
    # ffmpeg for video encoding
    ffmpeg \
    # extra utils
    vim \
    curl \
    bash \
    # dependencies for php extensions
    $DEV_DEPENDENCIES

# install PHP extensions
RUN docker-php-ext-install \
    pdo_mysql \
    mysqli \
    bcmath \
    pcntl \
    sockets \
    opcache \
    exif \
    curl \
    gd \
    intl \
    zip \
    xsl \
    gettext \
    shmop \
    sysvmsg \
    sysvsem \
    sysvshm \
    pdo_pgsql \
    pgsql \
    pdo_sqlite


# install extensions from pecl
RUN pecl install -o -f redis mcrypt \
&& docker-php-ext-enable redis mcrypt

# remove build dependencies
RUN apk del $DEV_DEPENDENCIES

# install cronn the cron replacement
RUN wget "https://github.com/umputun/cronn/releases/download/v1.1.0/cronn_v1.1.0_linux_x86_64.tar.gz" && \
    tar -xzf cronn_v1.1.0_linux_x86_64.tar.gz && \
    mv cronn /usr/local/bin/cronn && \
    rm cronn_v1.1.0_linux_x86_64.tar.gz