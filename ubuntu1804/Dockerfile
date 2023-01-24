FROM ubuntu:18.04

ENV LANG C

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      git python3 python3-pip curl \
      g++-8 make autoconf pkg-config \
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
      nmap iproute2 telnet nghttp2 libnghttp2-dev python3.8 python3.8-venv

RUN ln -s /bin/ncat /usr/local/bin/nc

RUN curl -sSL https://github.com/summerwind/h2spec/releases/download/v2.6.0/h2spec_linux_amd64.tar.gz \
    | tar zxf - -C /usr/local/bin/

RUN python3.8 -m venv /venv
ENV PATH /venv/bin:$PATH
RUN pip install pipenv

ENV REPO https://github.com/apache/trafficserver
# 9.2.0
ENV COMMIT c26d71cc35acff7ad8a9a98de45433305be9318c

RUN mkdir -p /src/trafficserver
WORKDIR /src/trafficserver
RUN git init
RUN git remote add origin ${REPO}
RUN git fetch --depth 1 origin ${COMMIT}
RUN git checkout FETCH_HEAD
RUN autoreconf -if
RUN CXX=g++-8 CC=gcc-8 ./configure --enable-experimental-plugins --enable-example-plugins --prefix=/usr --enable-werror --enable-debug --enable-wccp --enable-luajit --enable-ccache
RUN make -j V=1
RUN make install
RUN make check V=1

WORKDIR /src/trafficserver/tests
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
RUN pipenv install

WORKDIR /src/trafficserver/tests
ENTRYPOINT ["pipenv", "run", "./autest.sh", "--ats-bin", "/usr/bin"]
CMD ["--sandbox", "/data/sandbox"]
