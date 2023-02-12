FROM ci.trafficserver.apache.org/ats/rockylinux:8

ENV ATS_USER trafficserver
ENV ATS_HOME /home/trafficserver
RUN adduser --system --create-home --home $ATS_HOME $ATS_USER

ENV REPO https://github.com/apache/trafficserver
ENV GITHUB_BRANCH main

USER $ATS_USER
ENV WORKSPACE $ATS_HOME/trafficserver
RUN git clone --depth 1 -b $GITHUB_BRANCH $REPO $WORKSPACE
WORKDIR $WORKSPACE
RUN git log -1 --pretty=fuller

WORKDIR $WORKSPACE/tests
RUN pipenv install

COPY build.sh /usr/local/bin/
ENV ATS_PREFIX /usr
WORKDIR $WORKSPACE
RUN /usr/local/bin/build.sh

USER root
WORKDIR $WORKSPACE
RUN make install

COPY run_autest.sh check.sh /usr/local/bin/
ENV SHARDCNT 0
ENV SHARD 0
WORKDIR $WORKSPACE/tests
ENTRYPOINT ["/bin/bash", "-x", "/usr/local/bin/run_autest.sh"]
