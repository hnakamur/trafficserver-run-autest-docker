#!/bin/bash -x
#set +e
# We want to pick up the OpenSSL-QUIC version of curl in /opt/bin.
# The HTTP/3 AuTests depend upon this, so update the PATH accordingly.
export PATH=/opt/bin:${PATH}

mkdir -p ${WORKSPACE}/output/${GITHUB_BRANCH}

# Make all files which will be created during tests writable by nobody user.
umask 0000

if [ ${SHARDCNT:-0} -le 0 ]; then
	./autest.sh --ats-bin ${ATS_PREFIX:-/tmp/ats}/bin/ --sandbox /tmp/sandbox "$@" || true
else
	testsall=( $( find . -iname "*.test.py" | awk -F'/' '{print $NF}' | awk -F'.' '{print $1}' ) )

	testsall=( $(
		for el in  "${testsall[@]}" ; do
			echo $el
		done | sort) )
	ntests=${#testsall[@]}

	shardsize=$((${ntests} / ${SHARDCNT}))
	[ 0 -ne $((${ntests} % ${shardsize})) ] && shardsize=$((${shardsize} + 1))
	shardbeg=$((${shardsize} * ${SHARD}))
	sliced=${testsall[@]:${shardbeg}:${shardsize}}
	./autest.sh --ats-bin ${ATS_PREFIX:-/tmp/ats}/bin/ --sandbox /tmp/sandbox -f ${sliced[@]} || true
fi

if [ -n "$(ls -A /tmp/sandbox/)" ]; then
	cp -rf /tmp/sandbox/ ${WORKSPACE}/output/${GITHUB_BRANCH}/
	exit 1
else
	if [ ${SHARDCNT:-0} -le 0 ]; then
		touch ${WORKSPACE}/output/${GITHUB_BRANCH}/No_autest_failures
	else
		touch ${WORKSPACE}/output/${GITHUB_BRANCH}/No_autest_failures_shard_${SHARD}
	fi
	exit 0
fi
