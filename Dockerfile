FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install wget and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    tar \
    make \
    gcc \
    g++ \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download using wget with retry
RUN cd /tmp && \
    wget --tries=3 --timeout=30 -O mtproxy.tar.gz https://github.com/TelegramMessenger/MTProxy/archive/master.tar.gz && \
    tar -xzf mtproxy.tar.gz && \
    mv MTProxy-master /MTProxy && \
    cd /MTProxy && \
    make

WORKDIR /MTProxy/objs/bin

EXPOSE 443

CMD SECRET=$(head -c 16 /dev/urandom | xxd -ps) && \
    echo "✅ MTProto Proxy Ready!" && \
    echo "Secret: $SECRET" && \
    echo "Port: 443" && \
    ./mtproto-proxy -u -p 8888 -H 443 -S "$SECRET" -M 1
