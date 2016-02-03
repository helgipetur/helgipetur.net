ifndef COMPONENT
	COMPONENT := gocd
endif

ifndef PROJECT_NAME
	PROJECT_NAME := nectar
endif

ifndef CLOUD_PROVIDER
	CLOUD_PROVIDER := aws
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

ifndef KUBE_AWS_ZONE
	KUBE_AWS_ZONE := eu-west-1c
endif

ifndef KUBE_AWS_ZONE
	KUBE_AWS_ZONE := eu-west-1c
endif

ifndef REGISTRY_URL_SERVER
	REGISTRY_URL_SERVER := ${REGISTRY_HOST}/${PROJECT_ID}/${COMPONENT}-server:${DOCKER_VERSION_TAG}
endif

ifndef REGISTRY_URL_AGENT
	REGISTRY_URL_AGENT := ${REGISTRY_HOST}/${PROJECT_ID}/${COMPONENT}-agent:${DOCKER_VERSION_TAG}
endif

ifndef DATA_DISK_NAME
	DATA_DISK_NAME := ${PROJECT_NAME}-${COMPONENT}-data
endif

ifndef AWS_DATA_VOLUME_ID
	AWS_DATA_VOLUME_ID := $(aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}" | ../util/get-aws-volumeid-by-name.py)
endif

ifndef AWS_CONFIG_VOLUME_ID
	AWS_CONFIG_VOLUME_ID := $(aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}-config" | ../util/get-aws-volumeid-by-name.py)
endif

all: service

docker:
	docker build -t ${REGISTRY_URL_AGENT} -f Dockerfile.agent .
	gcloud docker push ${REGISTRY_URL_AGENT}

service:
	kubectl create -f ${COMPONENT}.rc.yaml
	kubectl create -f ${COMPONENT}.agents.rc.yaml
	kubectl create -f ${COMPONENT}.service.yaml

controller-aws:
	cat gocd.rc.aws.yaml | \
	AWS_DATA_VOLUME_ID=`aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}" | ../util/get-aws-volumeid-by-name.py` \
	AWS_CONFIG_VOLUME_ID=`aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}-config" | ../util/get-aws-volumeid-by-name.py` \
	KUBE_AWS_ZONE=${KUBE_AWS_ZONE} \
	../util/env_replace.py AWS_DATA_VOLUME_ID AWS_CONFIG_VOLUME_ID KUBE_AWS_ZONE | kubectl create -f -	

build-agent:
	docker build -t ${REGISTRY_URL_AGENT} -f Dockerfile.agent .
	docker push ${REGISTRY_URL_AGENT}

agents-aws: build-agent
	kubectl create -f ${COMPONENT}.agents.rc.yaml

service-aws:
	kubectl create -f ${COMPONENT}.service.yaml

aws: controller-aws agents-aws service-aws

rebuild-agents-aws: clean-agents build-agent agents-aws

clean: clean-service clean-agents clean-controller

clean-service:
	kubectl delete -f ${COMPONENT}.service.yaml

clean-agents:
	kubectl delete -f ${COMPONENT}.agents.rc.yaml

clean-controller:
	kubectl delete -f ${COMPONENT}.rc.yaml

clean-disks-aws:
	# Use with caution!	
	(aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}-config" | ../util/get-aws-volumeid-by-name.py) && aws ec2 delete-volume --volume-id `aws ec2 describe-volumes  --filters Name=tag-value,Values="${DATA_DISK_NAME}-config" | ../util/get-aws-volumeid-by-name.py`
	(aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}" | ../util/get-aws-volumeid-by-name.py) && aws ec2 delete-volume --volume-id `aws ec2 describe-volumes  --filters Name=tag-value,Values="${DATA_DISK_NAME}" | ../util/get-aws-volumeid-by-name.py`

clean-disks-gce:
	gcloud compute disks describe ${DATA_DISK_NAME} && gcloud compute disks delete ${DATA_DISK_NAME}
	gcloud compute disks describe ${DATA_DISK_NAME}-config && gcloud compute disks delete ${DATA_DISK_NAME}-config
	# gcloud compute disks describe ${BUILD_DISK_NAME}-1 || gcloud compute disks create ${BUILD_DISK_NAME}-1 --size 200GB

disks-aws:
	(aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}-config" | ../util/volume-exists.py) || aws ec2 create-tags --resources `aws ec2 create-volume --availability-zone ${KUBE_AWS_ZONE} --size 10 --volume-type gp2 | ../util/get-aws-volumeid.py` --tags Key=Name,Value=${DATA_DISK_NAME}-config
	(aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}" | ../util/volume-exists.py) || aws ec2 create-tags --resources `aws ec2 create-volume --availability-zone ${KUBE_AWS_ZONE} --size 200 --volume-type gp2 | ../util/get-aws-volumeid.py` --tags Key=Name,Value=${DATA_DISK_NAME}

disks-gce:
	gcloud compute disks describe ${DATA_DISK_NAME} || gcloud compute disks create ${DATA_DISK_NAME} --size 200GB
	gcloud compute disks describe ${DATA_DISK_NAME}-config || gcloud compute disks create ${DATA_DISK_NAME}-config --size 10GB
	# gcloud compute disks describe ${BUILD_DISK_NAME}-1 || gcloud compute disks create ${BUILD_DISK_NAME}-1 --size 200GB

disks:
	@make -C . disks-${CLOUD_PROVIDER}

clean-disks:
	@make -C . clean-disks-${CLOUD_PROVIDER}

restart-pod:
	kubectl delete -f ${COMPONENT}.rc.yaml
	kubectl create -f ${COMPONENT}.rc.yaml
