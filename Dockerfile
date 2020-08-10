FROM debian:stable-slim as builder

  RUN apt-get update \
      && apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        curl \
        freetds-dev \
        gawk \
        git \
        libsqlite3-dev \
        libssl1.1 \
        libzip-dev \
        make \
        openssl \
        patch \
        time \
        unzip \
        wget \
        cl-ironclad \
        cl-babel \
      && rm -rf /var/lib/apt/lists/*

  RUN curl -SL https://github.com/Clozure/ccl/releases/download/v1.11.5/ccl-1.11.5-linuxx86.tar.gz \
      | tar xz -C /usr/local/src/ \
      && mv /usr/local/src/ccl/scripts/ccl64 /usr/local/bin/ccl

RUN git clone https://github.com/dimitri/pgloader.git /opt/src/pgloader \
      && cd /opt/src/pgloader \
      && git checkout tags/v3.6.2 -b v3.6.2

RUN mkdir -p /opt/src/pgloader/build/bin \
      && cd /opt/src/pgloader \
      && make CL=ccl DYNSIZE=256 clones save

FROM debian:stable-slim

  RUN apt-get update \
      && apt-get install -y --no-install-recommends \
        curl \
        freetds-dev \
        gawk \
        libsqlite3-dev \
        libssl1.1 \
        libzip-dev \
        make \
        sbcl \
        unzip \
      && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/src/pgloader/build/bin/pgloader /usr/local/bin
COPY insert.sql insert.sql
COPY insert_hom.sql insert_hom.sql
COPY load.pgloader load.pgloader
COPY hom_load.pgloader hom_load.pgloader
COPY run.sh run.sh
