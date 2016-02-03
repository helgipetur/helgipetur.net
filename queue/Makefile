ifndef COMPONENT
	COMPONENT := rabbitmq
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

all: service

service:
	@kubectl create -f ${COMPONENT}.master.rc.yaml
	@kubectl create -f ${COMPONENT}.master.service.yaml

clean:
	@echo "Note that disks remain, you can clean them up with `clean-disks`"
	@kubectl delete -f ${COMPONENT}.master.service.yaml || echo Service does not exist
	@kubectl delete -f ${COMPONENT}.master.rc.yaml || echo Controller does not exist

clean-disks:
	# Use with caution!
	@gcloud compute disks describe ${DATA_DISK_NAME} && gcloud compute disks delete ${DATA_DISK_NAME}

disks:
	@gcloud compute disks describe ${DATA_DISK_NAME} || gcloud compute disks create ${DATA_DISK_NAME} --size 200GB

restart-pod:
	@kubectl delete -f ${COMPONENT}.master.rc.yaml
	@kubectl create -f ${COMPONENT}.master.rc.yaml
