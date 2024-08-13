FROM docker.io/webdevops/php:8.3

WORKDIR /app

# install ffmpeg for video encoding
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg

# install cronn the cron replacement
RUN wget "https://github.com/umputun/cronn/releases/download/v1.0.0/cronn_v1.0.0_linux_amd64.deb" && \
    apt install ./cronn_v1.0.0_linux_amd64.deb || true && \
    rm -f cronn_v1.0.0_linux_amd64.deb

# clean the apt cache only after installing all packages
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*


ARG UID=1000
COPY --chown=$UID . .
