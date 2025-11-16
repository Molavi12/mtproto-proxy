# Build stage
FROM ubuntu:22.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/TelegramMessenger/MTProxy.git && \
    cd MTProxy && \
    make

# Runtime stage
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libssl3 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Copy built binary from builder stage
COPY --from=builder /MTProxy/objs/bin/mtproto-proxy /usr/local/bin/mtproto-proxy

COPY light-start.sh /light-start.sh
RUN chmod +x /light-start.sh

EXPOSE 443

CMD ["/start.sh"]
