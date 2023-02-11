# syntax=docker/dockerfile:1.2
FROM ci.trafficserver.apache.org/ats/rockylinux:8

ENV REPO https://github.com/apache/trafficserver
ENV GITHUB_BRANCH master

ENV WORKSPACE /src/trafficserver
RUN git clone --depth 1 -b ${GITHUB_BRANCH} ${REPO} ${WORKSPACE}
RUN chown -R nobody:nobody ${WORKSPACE}

WORKDIR ${WORKSPACE}/tests
RUN pipenv install

COPY build.sh /src/
ENV ATS_PREFIX /usr/ats
ENV CCACHE_DIR /tmp/ccache
ENV CCACHE_BASEDIR ${WORKSPACE}
WORKDIR ${WORKSPACE}
RUN --mount=type=cache,target=${CCACHE_BASEDIR} \
    /src/build.sh

COPY run_autest.sh /src/
ENV SHARDCNT 0
ENV SHARD 0
WORKDIR ${WORKSPACE}/tests
ENTRYPOINT ["/bin/bash", "-x", "/src/run_autest.sh"]
