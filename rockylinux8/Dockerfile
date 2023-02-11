# syntax=docker/dockerfile:1.2
FROM ci.trafficserver.apache.org/ats/rockylinux:8

ENV REPO https://github.com/hnakamur/trafficserver
ENV COMMIT b613715f2ab1cf53c743f9a0b75cbf6b09c15ab8

ENV WORKSPACE /src/trafficserver
RUN mkdir -p ${WORKSPACE}
WORKDIR ${WORKSPACE}
RUN git init
RUN git remote add origin ${REPO}
RUN git fetch --depth 1 origin ${COMMIT}
RUN git checkout FETCH_HEAD

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
ENV GITHUB_BRANCH master
ENV SHARDCNT 0
ENV SHARD 0
WORKDIR ${WORKSPACE}/tests
ENTRYPOINT ["/bin/bash", "-x", "/src/run_autest.sh"]
