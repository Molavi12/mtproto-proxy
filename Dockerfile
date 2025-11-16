FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    wget \
    tar \
    make \
    gcc \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Download MTProxy using curl instead of git
RUN cd /tmp && \
    curl -L -o mtproxy.tar.gz https://github.com/TelegramMessenger/MTProxy/archive/master.tar.gz && \
    tar -xzf mtproxy.tar.gz && \
    mv MTProxy-master /MTProxy && \
    cd /MTProxy && \
    make

EXPOSE 443

CMD cd /MTProxy/objs/bin && \
    SECRET=$(head -c 16 /dev/urandom | xxd -ps) && \
    echo "===========================================" && \
    echo "✅ MTProto Proxy is running!" && \
    echo "🔑 Secret: $SECRET" && \
    echo "📍 Port: 443" && \
    echo "📱 Use this in Telegram proxy settings" && \
    echo "===========================================" && \
    ./mtproto-proxy -u -p 8888 -H 443 -S "$SECRET" -M 1
