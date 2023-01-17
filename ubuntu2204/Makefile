build:
	docker build -t ats920rc0-ubuntu2204 .

run:
	docker run --rm -it --cap-add=SYS_PTRACE ats920rc0-ubuntu2204 bash

exec:
	docker exec -it $$(docker ps -lq) bash

getlogs:
	docker run -d --rm -it ats920rc0-ubuntu2204 bash
	echo -n configure.log make.log make-install.log autest.log | xargs -d ' ' -I {} docker cp $$(docker ps -lq):/src/{} {}
	docker stop $$(docker ps -lq)
