FROM ubuntu:20.04

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
      zlib1g-dev libgeoip-dev \
      # autest stuff
      ncat iproute2 telnet nghttp2 libnghttp2-dev 

RUN curl -sSL https://github.com/summerwind/h2spec/releases/download/v2.6.0/h2spec_linux_amd64.tar.gz \
    | tar zxf - -C /usr/local/bin/

RUN pip install pipenv
ENV PATH /src/.local/bin:$PATH

ENV REPO https://github.com/hnakamur/trafficserver
ENV COMMIT b1f0947cb7ee9ac71ace5b500d2eb17787d0708b

RUN mkdir -p /build-log /src/trafficserver
WORKDIR /src/trafficserver
RUN git init
RUN git remote add origin ${REPO}
RUN git fetch --depth 1 origin ${COMMIT}
RUN git checkout FETCH_HEAD
RUN autoreconf -if
RUN ./configure --enable-experimental-plugins --enable-example-plugins --prefix=/usr --enable-werror --enable-debug --enable-wccp --enable-luajit --enable-ccache 2>&1 | tee /build-log/configure.log
RUN CXX=g++-12 CC=gcc-12 make -j 2>&1 | tee /build-log/make.log
RUN make install 2>&1 | tee /build-log/make-install.log

WORKDIR /src/trafficserver/tests
RUN pipenv install

WORKDIR /src/trafficserver/tests
ENTRYPOINT ["pipenv", "run", "./autest.sh", "--ats-bin", "/usr/bin"]
CMD ["--sandbox", "/data/sandbox"]
