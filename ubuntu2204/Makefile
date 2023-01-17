IMAGE = ats920rc0-ubuntu2204

build:
	docker build -t $(IMAGE) .

getlogs:
	docker run -d --rm -it --entrypoint bash $(IMAGE)
	echo -n configure.log make.log make-install.log | xargs -d ' ' -I {} docker cp $$(docker ps -lq):/build-log/{} ./log/
	docker stop $$(docker ps -lq)

test:
	mkdir -p ./log ./data
	docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v $${HOME}/ccache:/tmp/ccache:rw \
		-v $${PWD}/data:/data:rw \
		$(IMAGE) 2>&1 | tee ./log/autest.log

test-filter:
	mkdir -p ./log ./sandbox
	docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v $${HOME}/ccache:/tmp/ccache:rw \
		-v $${PWD}/data:/data:rw \
		$(IMAGE) --sandbox /data/sandbox-$(test) -f $(test) 2>&1 \
		| tee ./data/autest-$(test).log

run:
	mkdir -p ./log
	docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v $${HOME}/ccache:/tmp/ccache:rw \
		-v $${PWD}/data:/data:rw \
		--entrypoint bash $(IMAGE)

exec:
	docker exec -it $$(docker ps -lq) bash
