FROM ubuntu:18.04

RUN true \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
        build-essential \
        qt5-default \
        python \
    && rm -rf /var/cache/apt/archives \
    && true

WORKDIR /build

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
