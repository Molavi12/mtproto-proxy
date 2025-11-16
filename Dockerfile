FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install git and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    make \
    gcc \
    g++ \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone directly with git
RUN git clone https://github.com/TelegramMessenger/MTProxy.git /MTProxy && \
    cd /MTProxy && \
    make

WORKDIR /MTProxy/objs/bin

EXPOSE 443

CMD SECRET=$(head -c 16 /dev/urandom | xxd -ps) && \
    echo "✅ MTProto Proxy Deployed!" && \
    echo "Secret: $SECRET" && \
    ./mtproto-proxy -u -p 8888 -H 443 -S "$SECRET" -M 1
