ifndef COMPONENT
	COMPONENT := nginx
endif

ifndef PROJECT_NAME
	PROJECT_NAME := nectar
endif

ifndef PROJECT_ID
	PROJECT_ID := kolibri-nectar
endif

ifndef REGISTRY_HOST
	REGISTRY_HOST := gcr.io
endif

ifndef DOCKER_VERSION_TAG
	DOCKER_VERSION_TAG := latest
endif

ifndef REGISTRY_URL
	REGISTRY_URL := ${REGISTRY_HOST}/${PROJECT_ID}/${COMPONENT}:${DOCKER_VERSION_TAG}
endif

ifndef DATA_DISK_NAME
	DATA_DISK_NAME := ${PROJECT_NAME}-${COMPONENT}-data
endif

ifndef ADMIN_PASSWORD
	ADMIN_PASSWORD := Samsti11ingNC
endif

all: htpasswd docker service

htpasswd:
	@which htpasswd || echo "-= This command requires htpasswd =-"
	@echo ${ADMIN_PASSWORD} | htpasswd -i -c .htpasswd admin

docker:
	@docker build -t ${REGISTRY_URL} .
	@gcloud docker push ${REGISTRY_URL}

service:
	@kubectl create -f ${COMPONENT}.rc.yaml
	@kubectl create -f ${COMPONENT}.service.yaml

clean:
	@rm -f .htpasswd
	@kubectl delete -f ${COMPONENT}.service.yaml || echo Service does not exist
	@kubectl delete -f ${COMPONENT}.rc.yaml || echo ResourceController does not exist

restart-pod:
	@kubectl delete -f ${COMPONENT}.rc.yaml
	@kubectl create -f ${COMPONENT}.rc.yaml
