FROM ubuntu:22.04

ENV LANG C

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      git python3 python3-pip curl \
      g++-12 make autoconf pkg-config \
      libssl-dev tcl-dev libexpat1-dev \
      libpcre3-dev libtool libcap-dev graphviz \
      libluajit-5.1-dev libboost-dev libhwloc-dev default-libmysqlclient-dev \
      python3-distro libxml2-dev libncurses-dev libcurl4-openssl-dev libhiredis-dev \
      libkyotocabinet-dev libmemcached-dev libbrotli-dev \
      libcrypto++-dev libjansson-dev libcjose-dev libyaml-cpp-dev \
      libunwind-dev \
      python3-sphinx plantuml python3-sphinxcontrib.plantuml \
      libmaxminddb-dev \
      zlib1g-dev libgeoip-dev

RUN curl -sSL https://github.com/summerwind/h2spec/releases/download/v2.6.0/h2spec_linux_amd64.tar.gz \
    | tar zxf - -C /usr/local/bin/

RUN useradd -m -d /src trafficserver
USER trafficserver
WORKDIR /src
RUN pip install --user pipenv
ENV PATH /src/.local/bin:$PATH

RUN git clone --depth 1 --branch 9.2.0-rc0 https://github.com/apache/trafficserver
WORKDIR /src/trafficserver
RUN autoreconf -if
RUN ./configure --enable-experimental-plugins --enable-example-plugins --prefix=/usr --enable-werror --enable-debug --enable-wccp --enable-luajit --enable-ccache 2>&1 | tee /src/configure.log
RUN CXX=g++-12 CC=gcc-12 make -j 2>&1 | tee /src/make.log

USER root
WORKDIR /src/trafficserver
RUN make install 2>&1 | tee /src/make-install.log

USER trafficserver
WORKDIR /src/trafficserver/tests
RUN pipenv install
RUN mkdir /src/autest-sandbox
RUN pipenv run ./autest.sh --ats-bin /usr/bin --sandbox /src/autest-sandbox 2>&1 | tee /src/autest.log
