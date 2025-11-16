FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies with clean apt
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    wget \
    tar \
    make \
    gcc \
    g++ \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create directory and set permissions
RUN mkdir -p /app && chmod 755 /app

WORKDIR /app

# Download and extract MTProxy
RUN curl -L -o mtproxy.tar.gz https://github.com/TelegramMessenger/MTProxy/archive/master.tar.gz && \
    tar -xzf mtproxy.tar.gz && \
    mv MTProxy-master MTProxy && \
    rm mtproxy.tar.gz

# Build MTProxy
WORKDIR /app/MTProxy
RUN make

# Create runtime directory
RUN mkdir -p /var/run/mtproxy

WORKDIR /app/MTProxy/objs/bin

EXPOSE 443

CMD SECRET=$(head -c 16 /dev/urandom | xxd -ps) && \
    echo "🚀 MTProto Proxy Started!" && \
    echo "🔑 Secret: $SECRET" && \
    echo "📍 Port: 443" && \
    echo "📱 Add this proxy in Telegram settings" && \
    echo "======================================" && \
    ./mtproto-proxy -u -p 8888 -H 443 -S "$SECRET" -M 1
