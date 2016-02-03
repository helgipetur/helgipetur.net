ifndef PROJECT_ID
	PROJECT_ID := kolibri-nectar
endif

ifndef KUBE_GCE_ZONE
	KUBE_GCE_ZONE := europe-west1-c
endif

ifndef NUM_MINIONS
	NUM_MINIONS := 4
endif

ifndef MINION_SIZE
	MINION_SIZE := t2.medium
endif

ifndef MASTER_SIZE
	MASTER_SIZE := ${MINION_SIZE}
endif

ifndef MINION_DISK_SIZE
	MINION_DISK_SIZE := 200GB
endif

ifndef KUBERNETES_PROVIDER
	KUBERNETES_PROVIDER := aws
endif

ifndef KUBE_LOGGING_DESTINATION
	KUBE_LOGGING_DESTINATION := elasticsearch
endif

ifndef PROJECT_NAME
	PROJECT_NAME := nectar
endif

ifndef DNS_DOMAIN
	DNS_DOMAIN := ${PROJECT_NAME}.local
endif

ifndef KUBE_OS_DISTRIBUTION
	KUBE_OS_DISTRIBUTION := coreos
endif

ifndef KUBE_AWS_ZONE
	KUBE_AWS_ZONE := eu-west-1c
endif

ifndef AWS_S3_REGION
	AWS_S3_REGION := eu-west-1
endif

ifndef AWS_S3_BUCKET
	AWS_S3_BUCKET := ${PROJECT_NAME}-kubernetes-artifacts
endif


all: cluster services

clean:
	make -C jenkins/ clean
	make -C nginx/ clean

services:
	make -C jenkins/
	make -C nginx/

provision:
	test -d kubernetes || (curl https://github.com/kubernetes/kubernetes/releases/download/v1.1.2/kubernetes.tar.gz -o /tmp/kubernetes.tgz -L && tar zxf /tmp/kubernetes.tgz)

cluster: provision
	KUBERNETES_PROVIDER=${KUBERNETES_PROVIDER} \
	KUBE_GCE_ZONE=${KUBE_GCE_ZONE} \
	KUBE_AWS_ZONE=${KUBE_AWS_ZONE} \
	NUM_MINIONS=${NUM_MINIONS} \
	MINION_SIZE=${MINION_SIZE} \
	AWS_S3_REGION=${AWS_S3_REGION} \
	AWS_S3_BUCKET=${AWS_S3_BUCKET} \
	INSTANCE_PREFIX=${PROJECT_NAME} \
	KUBE_LOGGING_DESTINATION=${KUBE_LOGGING_DESTINATION} \
	PROJECT_ID=${PROJECT_ID} \
	MINION_DISK_SIZE=${MINION_DISK_SIZE} \
	DNS_DOMAIN=${DNS_DOMAIN} \
	MASTER_SIZE=${MASTER_SIZE} \
	DNS_DOMAIN=nectar.local \
	kubernetes/cluster/kube-up.sh
	# gcloud container clusters create ${PROJECT_NAME} --no-enable-cloud-logging --no-enable-cloud-monitoring --password ${CLUSTER_PASSWORD}

destroy:
	KUBERNETES_PROVIDER=${KUBERNETES_PROVIDER} \
	KUBE_GCE_ZONE=${KUBE_GCE_ZONE} \
	KUBE_AWS_ZONE=${KUBE_AWS_ZONE} \
	KUBE_LOGGING_DESTINATION=${KUBE_LOGGING_DESTINATION} \
	PROJECT_ID=${PROJECT_ID} \
	MINION_DISK_SIZE=${MINION_DISK_SIZE} \
	INSTANCE_PREFIX=nectar \
	DNS_DOMAIN=${DNS_DOMAIN} \
	kubernetes/cluster/kube-down.sh
