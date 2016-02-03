ifndef COMPONENT
	COMPONENT := docker-registry
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

ifndef KUBE_AWS_ZONE
	KUBE_AWS_ZONE := eu-west-1c
endif

ifndef DATA_DISK_NAME
	DATA_DISK_NAME := ${PROJECT_NAME}-${COMPONENT}-data
endif

ifndef DATA_DISK_SIZE
	DATA_DISK_SIZE := 200
endif

all: service

service-gce: disks-gce
	@echo "Don't use this for GCE, use GCR"

service-aws: disks-aws
	cat docker-registry.rc.aws.yaml | \
	AWS_DATA_VOLUME_ID=`aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}" | ../util/get-aws-volumeid-by-name.py` \
	KUBE_AWS_ZONE=${KUBE_AWS_ZONE} \
	../util/env_replace.py AWS_DATA_VOLUME_ID KUBE_AWS_ZONE | kubectl create -f -
	kubectl create -f ${COMPONENT}.service.yaml

service:
	make -C . service-${CLOUD_PROVIDER}

clean:
	kubectl delete -f ${COMPONENT}.service.yaml
	kubectl delete -f ${COMPONENT}.rc.yaml

clean-disks-aws:
	# Use with caution!	
	(aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}" | ../util/get-aws-volumeid-by-name.py) && aws ec2 delete-volume --volume-id `aws ec2 describe-volumes  --filters Name=tag-value,Values="${DATA_DISK_NAME}" | ../util/get-aws-volumeid-by-name.py`

clean-disks-gce:
	@echo "Don't use this for GCE, use GCR"

disks-aws:
	(aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}" | ../util/volume-exists.py) || aws ec2 create-tags --resources `aws ec2 create-volume --availability-zone ${KUBE_AWS_ZONE} --size ${DATA_DISK_SIZE} --volume-type gp2 | ../util/get-aws-volumeid.py` --tags Key=Name,Value=${DATA_DISK_NAME}

disks-gce:
	@echo "Don't use this for GCE, use GCR"

disks:
	@make -C . disks-${CLOUD_PROVIDER}

clean-disks:
	@make -C . clean-disks-${CLOUD_PROVIDER}

restart-pod:
	kubectl delete -f ${COMPONENT}.rc.aws.yaml
	cat docker-registry.rc.aws.yaml | \
	AWS_DATA_VOLUME_ID=`aws ec2 describe-volumes --filters Name=tag-value,Values="${DATA_DISK_NAME}" | ../util/get-aws-volumeid-by-name.py` \
	KUBE_AWS_ZONE=${KUBE_AWS_ZONE} \
	../util/env_replace.py AWS_DATA_VOLUME_ID KUBE_AWS_ZONE | kubectl create -f -
