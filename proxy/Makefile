all: docker controller service

docker:
	docker build -t nectar-registry.kolibri.is/nectar/nginx-proxy:latest .
	docker push nectar-registry.kolibri.is/nectar/nginx-proxy:latest

bash:
	docker run -it --rm nectar-registry.kolibri.is/nectar/nginx-proxy bash

controller:
	kubectl create -f nectar-proxy.rc.yaml

rebuild: docker
	kubectl delete -f nectar-proxy.rc.yaml
	kubectl create -f nectar-proxy.rc.yaml

service:
	kubectl create -f nectar-proxy.service.yaml
