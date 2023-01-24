IMAGE = ats920-ubuntu2204

build:
	mkdir -p ./log
	docker build $(DOCKER_BUILD_OPTS) -t $(IMAGE) . 2>&1 | tee ./log/build.log

test:
	mkdir -p ./log ./data
	docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v $${PWD}/data:/data:rw \
		$(IMAGE) 2>&1 | tee ./log/autest.log

test-filter:
	mkdir -p ./log ./data
	docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v $${PWD}/data:/data:rw \
		$(IMAGE) --sandbox /data/sandbox-$(test) -f $(test) 2>&1 \
		| tee ./log/autest-$(test).log

run:
	mkdir -p ./log
	docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v $${PWD}/data:/data:rw \
		--entrypoint bash $(IMAGE)

exec:
	docker exec -it $$(docker ps -lq) bash
