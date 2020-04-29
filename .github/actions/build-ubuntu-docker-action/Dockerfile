FROM ubuntu:18.04

RUN true \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
        build-essential \
        qt5-default \
    && rm -rf /var/cache/apt/archives \
    && true

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
