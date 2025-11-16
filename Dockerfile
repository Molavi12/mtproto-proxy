FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

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

# Download specific release or commit
RUN wget -O mtproxy.tar.gz "https://github.com/TelegramMessenger/MTProxy/archive/refs/heads/master.tar.gz" && \
    tar -xzf mtproxy.tar.gz && \
    mv MTProxy-master /MTProxy && \
    rm mtproxy.tar.gz

WORKDIR /MTProxy

RUN make

WORKDIR /MTProxy/objs/bin

EXPOSE 443

CMD SECRET=$(head -c 16 /dev/urandom | xxd -ps) && \
    echo "✅ MTProto Proxy Deployed!" && \
    echo "Secret: $SECRET" && \
    ./mtproto-proxy -u -p 8888 -H 443 -S "$SECRET" -M 1
