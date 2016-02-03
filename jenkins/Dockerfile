FROM jenkins
MAINTAINER Kolibri ehf.
USER root
RUN apt-get update && apt-get install build-essential -yqq
RUN groupadd -g 999 docker && usermod -a -G docker jenkins
USER jenkins
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
