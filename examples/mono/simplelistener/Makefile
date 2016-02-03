ifndef COMPONENT
	COMPONENT := simpleservice
endif

ifndef PROJECT_NAME
	PROJECT_NAME := mono
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

all: build test

build: dockerbase
	docker build -t ${REGISTRY_URL} .

dockerbase:
	make -C ../dockerbase

clean:
	rm -rf obj/ bin/

run:
	docker run -it ${REGISTRY_URL}

test:
	docker run ${REGISTRY_URL} nunit-console ${COMPONENT}_tests.dll
