IMAGE = ats920rc0-ubuntu2004

build:
	docker build -t $(IMAGE) .

getlogs:
	docker run -d --rm -it --entrypoint bash $(IMAGE)
	echo -n configure.log make.log make-install.log | xargs -d ' ' -I {} docker cp $$(docker ps -lq):/build-log/{} ./log/
	docker stop $$(docker ps -lq)


test:
	mkdir -p ./log
	docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v $${HOME}/ccache:/tmp/ccache:rw \
		-v $${PWD}/log:/test-log:rw \
		-v $${PWD}/sandbox:/sandbox:rw \
		$(IMAGE) 2>&1 | tee ./log/autest.log

run:
	mkdir -p ./log
	docker run --rm -it --init --cap-add=SYS_PTRACE \
		-v $${HOME}/ccache:/tmp/ccache:rw \
		-v $${PWD}/log:/test-log:rw \
		-v $${PWD}/sandbox:/sandbox:rw \
		--entrypoint bash $(IMAGE)

exec:
	docker exec -it $$(docker ps -lq) bash
