IMAGE = ats-ubuntu2004

.PHONY: build check test test-shard test-filter run exec

build:
	mkdir -p ./log
	time docker build $(DOCKER_BUILD_OPTS) -t $(IMAGE) . 2>&1 | tee ./log/build.log

check:
	mkdir -p ./log
	time docker run --rm -it --init --cap-add=SYS_PTRACE \
		--entrypoint=bash $(IMAGE) -c check.sh 2>&1 | tee ./log/check.log

test:
	mkdir -p ./log ./data
	time docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v $${PWD}/data:/home/trafficserver/trafficserver/output:rw \
		$(IMAGE) 2>&1 | tee ./log/autest.log &

test-shard:
	IMAGE=$(IMAGE) SHARDCNT=$${SHARDCNT:-4} ./test-shard.sh

# Run this target like:
# make test-filter test=test_name_to_run
test-filter:
	mkdir -p ./log ./data
	time docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v $${PWD}/data:/home/trafficserver/trafficserver/output:rw \
		$(IMAGE) -f $(test) 2>&1 \
		| tee ./log/autest-$(test).log

run:
	mkdir -p ./log
	docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v $${PWD}/data:/home/trafficserver/trafficserver/output:rw \
		--entrypoint bash $(IMAGE)

exec:
	docker exec -it $$(docker ps -lq) bash
