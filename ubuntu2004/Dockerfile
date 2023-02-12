FROM ubuntu:20.04

ENV LANG C

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      git python3 python3-pip curl \
      g++-10 make autoconf pkg-config \
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
      ncat iproute2 telnet nghttp2 libnghttp2-dev sudo

RUN curl -sSL https://github.com/summerwind/h2spec/releases/download/v2.6.0/h2spec_linux_amd64.tar.gz \
    | tar zxf - -C /usr/local/bin/

ENV ATS_USER trafficserver
ENV ATS_HOME /home/trafficserver
RUN adduser --system --group --home $ATS_HOME $ATS_USER

USER $ATS_USER
RUN pip install --user pipenv
ENV PATH $ATS_HOME/.local/bin:$PATH

ENV REPO https://github.com/apache/trafficserver
ENV GITHUB_BRANCH master

ENV WORKSPACE $ATS_HOME/trafficserver
RUN git clone --depth 1 -b $GITHUB_BRANCH $REPO $WORKSPACE
WORKDIR $WORKSPACE
RUN git log -1 --pretty=fuller

WORKDIR $WORKSPACE/tests
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
RUN pipenv install

WORKDIR $WORKSPACE
ENV ATS_PREFIX /usr
RUN autoreconf -if
RUN CXX=g++-10 CC=gcc-10 ./configure --enable-experimental-plugins --enable-example-plugins \
    --prefix=$ATS_PREFIX --enable-werror --enable-debug --enable-wccp --enable-luajit
RUN make -j V=1

USER root
RUN make install

USER $ATS_USER
COPY run_autest.sh check.sh /usr/local/bin/
ENV SHARDCNT 0
ENV SHARD 0
WORKDIR $WORKSPACE/tests
ENTRYPOINT ["/bin/bash", "-x", "/usr/local/bin/run_autest.sh"]
