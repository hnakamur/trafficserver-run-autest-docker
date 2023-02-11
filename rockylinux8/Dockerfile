FROM ci.trafficserver.apache.org/ats/rockylinux:8

ENV REPO https://github.com/hnakamur/trafficserver
ENV GITHUB_BRANCH adjust_autest_for_rockylinux8

ENV WORKSPACE /src/trafficserver
RUN git clone --depth 1 -b ${GITHUB_BRANCH} ${REPO} ${WORKSPACE}
WORKDIR ${WORKSPACE}
RUN git log -1 --pretty=fuller

WORKDIR ${WORKSPACE}/tests
RUN pipenv install

COPY build.sh /src/
ENV ATS_PREFIX /usr/ats
WORKDIR ${WORKSPACE}
RUN /src/build.sh

COPY run_autest.sh check.sh /src/
ENV SHARDCNT 0
ENV SHARD 0
WORKDIR ${WORKSPACE}/tests
ENTRYPOINT ["/bin/bash", "-x", "/src/run_autest.sh"]
