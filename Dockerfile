FROM php:8.2-fpm-alpine3.17

RUN echo "https://mirror.yandex.ru/mirrors/alpine/v3.17/main" > /etc/apk/repositories \
 && echo "https://mirror.yandex.ru/mirrors/alpine/v3.17/community" >> /etc/apk/repositories \
 && echo "https://mirror.yandex.ru/mirrors/alpine/v3.17/main" >> /etc/apk/repositories


# Переменная для установки временной зоны
ENV TZ=Europe/Moscow

# Подтягивание необходимых зависимостей

RUN apk update && apk add --no-cache \
nano curl-dev libzip-dev zip icu-dev \
freetype-dev libpng-dev libjpeg-turbo-dev \
libxml2-dev pcre-dev libc-dev \
libmcrypt-dev gettext autoconf cmake make gcc g++ \
tzdata vim musl-dev bash postgresql-dev yarn \
supervisor rabbitmq-c-dev rabbitmq-c linux-headers ffmpeg


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Возможные расширения PHP
#
# Possible values for ext-name:
# bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo filter ftp gd gettext gmp hash iconv imap
# interbase intl json ldap mbstring mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql
# pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline recode reflection session shmop
# simplexml snmp soap sockets sodium spl standard sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlreader
# xmlrpc xmlwriter xsl zend_test zip

RUN docker-php-ext-configure opcache --enable-opcache

RUN docker-php-ext-install \
zip bcmath intl pcntl curl \
pdo_pgsql pgsql sockets opcache

RUN pecl install -o -f redis mcrypt amqp \
&& docker-php-ext-enable redis mcrypt amqp opcache

WORKDIR /var/www/html
