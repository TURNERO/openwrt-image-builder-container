FROM debian:12-slim

# Install OpenWrt build prerequisites
RUN apt-get update && apt-get install -y \
    build-essential libncurses5-dev libncursesw5-dev \
    zlib1g-dev gawk git gettext libssl-dev xsltproc \
    wget unzip python3 python3-distutils file zstd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Default OpenWrt version and Target
ARG RELEASE=25.12.2
ARG TARGET=ramips
ARG SUBTARGET=mt7621
ARG PROFILE=zyxel_wsm20

# Download and unpack Image Builder
RUN wget https://downloads.openwrt.org/releases/${RELEASE}/targets/${TARGET}/${SUBTARGET}/openwrt-imagebuilder-${RELEASE}-${TARGET}-${SUBTARGET}.Linux-x86_64.tar.zst \
    && tar --zstd -xvf *.tar.zst --strip-components=1 \
    && rm *.tar.zst

# Create directory for custom files (startup scripts, etc.)
RUN mkdir -p files/etc/uci-defaults

COPY build.sh .
RUN chmod +x build.sh

CMD ["./build.sh"]
