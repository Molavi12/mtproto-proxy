FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone and build MTProxy
RUN git clone https://github.com/TelegramMessenger/MTProxy.git && \
    cd MTProxy && \
    make

# Create startup script directly in Dockerfile
RUN echo '#!/bin/bash\n\
cd /MTProxy/objs/bin\n\
SECRET=$(head -c 16 /dev/urandom | xxd -ps)\n\
echo "🚀 MTProto Proxy Started!"\n\
echo "🔑 Secret: $$SECRET"\n\
echo "📍 Port: 443"\n\
echo "📱 Add in Telegram with this secret"\n\
exec ./mtproto-proxy -u -p 8888 -H 443 -S "$$SECRET" -M 1' > /start.sh && \
    chmod +x /start.sh

EXPOSE 443

CMD ["/start.sh"]
