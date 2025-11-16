FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /build

# Step 1: Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    make \
    gcc \
    g++ \
    zlib1g-dev

# Step 2: Download
RUN curl -L -o mtproxy.tar.gz https://github.com/TelegramMessenger/MTProxy/archive/master.tar.gz
RUN ls -la

# Step 3: Extract
RUN tar -xzf mtproxy.tar.gz
RUN ls -la
RUN ls -la MTProxy-master/

# Step 4: Build
RUN cd MTProxy-master && make

# Step 5: Prepare final app
WORKDIR /app
RUN cp /build/MTProxy-master/objs/bin/mtproto-proxy ./
RUN chmod +x mtproto-proxy
RUN ls -la

EXPOSE 443

CMD echo "✅ Build successful!" && \
    SECRET=$(head -c 16 /dev/urandom | xxd -ps) && \
    echo "Secret: $SECRET" && \
    ./mtproto-proxy -u -p 8888 -H 443 -S "$SECRET" -M 1
