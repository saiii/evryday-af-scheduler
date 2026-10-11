DOCKER := podman
VERSION := 0.0.1

login:
	aws ecr get-login-password --region ap-southeast-1 | $(DOCKER) login --username AWS --password-stdin 126888715538.dkr.ecr.ap-southeast-1.amazonaws.com

build:
	$(DOCKER) build --platform linux/amd64 -t edaymastery.com/evryday-af-scheduler -f Dockerfile .
	$(DOCKER) save -o image.tar edaymastery.com/evryday-af-scheduler
	trivy image --input image.tar -f table --report summary --severity HIGH,CRITICAL --output trivy.out
	rm -f image.tar
	$(DOCKER) tag edaymastery.com/evryday-af-scheduler:latest 126888715538.dkr.ecr.ap-southeast-1.amazonaws.com/edaymastery.com/evryday-af-scheduler:$(VERSION)

test:
	$(DOCKER) run -it -p 3000:3000 --rm edaymastery.com/evryday-af-scheduler

publish:
	$(DOCKER) push 126888715538.dkr.ecr.ap-southeast-1.amazonaws.com/edaymastery.com/evryday-af-scheduler:$(VERSION)
