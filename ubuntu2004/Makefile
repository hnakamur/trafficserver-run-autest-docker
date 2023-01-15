build:
	docker build -t ats920rc0-ubuntu2004 .

getlogs:
	docker run -d --rm -it ats920rc0-ubuntu2004 bash
	echo -n configure.log make.log make-install.log autest.log | xargs -d ' ' -I {} docker cp $$(docker ps -lq):/src/{} {}
	docker stop $$(docker ps -lq)
