#!/bin/bash
mkdir -p ./log ./data
for (( shard = 0; shard < ${SHARDCNT}; shard++ )); do
	docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v ${PWD}/data:/src/trafficserver/output:rw \
		-e SHARD=${shard} -e SHARDCNT=${SHARDCNT} \
		${IMAGE} 2>&1 | tee ./log/autest-${shard}-of-${SHARDCNT}.log &
done
wait
