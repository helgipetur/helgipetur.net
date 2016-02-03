FROM mono:latest

MAINTAINER Jo Shields <jo.shields@xamarin.com>

RUN apt-get update && apt-get install mono-4.0-service nunit-console -y

RUN mkdir -p /usr/src/app/source /usr/src/app/build
WORKDIR /usr/src/app/source

ONBUILD COPY . /usr/src/app/source
ONBUILD RUN nuget restore -NonInteractive
ONBUILD RUN xbuild /property:Configuration=Debug /property:OutDir=/usr/src/app/build/
ONBUILD WORKDIR /usr/src/app/build
