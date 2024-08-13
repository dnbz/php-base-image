FROM docker.io/openswoole/swoole:php8.3-alpine

WORKDIR /app

# install ffmpeg for video encoding
RUN apk add --no-cache ffmpeg

# install cronn the cron replacement
RUN wget "https://github.com/umputun/cronn/releases/download/v1.1.0/cronn_v1.1.0_linux_x86_64.tar.gz" && \
    tar -xzf cronn_v1.1.0_linux_x86_64.tar.gz && \
    mv cronn /usr/local/bin/cronn && \
    rm cronn_v1.1.0_linux_x86_64.tar.gz