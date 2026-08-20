FROM cm2network/steamcmd:root-bookworm

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        lib32gcc-s1 \
        lib32stdc++6 \
        lib32z1 \
    && rm -rf /var/lib/apt/lists/*

COPY run-gmod-tests.sh /usr/local/bin/run-gmod-tests
RUN chmod 0755 /usr/local/bin/run-gmod-tests

ENTRYPOINT ["/usr/local/bin/run-gmod-tests"]
