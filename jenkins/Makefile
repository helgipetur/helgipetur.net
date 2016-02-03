ifndef COMPONENT
	COMPONENT := jenkins
endif

ifndef PROJECT_NAME
	PROJECT_NAME := nectar
endif

ifndef PROJECT_ID
	PROJECT_ID := kolibri-nectar
endif

ifndef REGISTRY_HOST
	REGISTRY_HOST := nectar-registry.kolibri.is
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

all: docker jenkins

aws: docker-push-aws controller-aws service

docker:
	docker build -t ${REGISTRY_URL} .

docker-push: docker
	gcloud docker push ${REGISTRY_URL}

docker-push-aws: docker
	docker push ${REGISTRY_URL}

controller:
	kubectl create -f ${COMPONENT}.rc.yaml

controller-aws:
	kubectl create -f ${COMPONENT}.rc.aws.yaml

rebuild-controller-aws: docker-push-aws clean-controller controller-aws

service:
	kubectl create -f ${COMPONENT}.service.yaml

clean-service:
	kubectl delete -f ${COMPONENT}.service.yaml

clean-controller:
	kubectl delete -f ${COMPONENT}.rc.yaml

clean-disks:
	# Use with caution!
	gcloud compute disks describe ${DATA_DISK_NAME} && gcloud compute disks delete ${DATA_DISK_NAME}

disks:
	gcloud compute disks describe ${DATA_DISK_NAME} || gcloud compute disks create ${DATA_DISK_NAME} --size 200GB
