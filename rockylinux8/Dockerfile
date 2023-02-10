FROM ci.trafficserver.apache.org/ats/rockylinux:8

ENV REPO https://github.com/apache/trafficserver
ENV COMMIT 086501cb58d7b872e955b49de952b554ba7b5685

RUN mkdir -p /src/trafficserver
COPY build.sh autest.sh /src/
WORKDIR /src/trafficserver
RUN git init
RUN git remote add origin ${REPO}
RUN git fetch --depth 1 origin ${COMMIT}
RUN git checkout FETCH_HEAD
RUN /src/build.sh

WORKDIR /src/trafficserver/tests
RUN mkdir -p /tmp/sandbox
ENV WORKSPACE /src/trafficserver
ENV GITHUB_BRANCH master
ENV SHARDCNT 0
CMD ["/bin/bash", "-x", "/src/autest.sh"]
