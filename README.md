# docker-activemq [![Docker Build](https://img.shields.io/docker/cloud/automated/lewinc/activemq)](https://hub.docker.com/r/lewinc/activemq/) [![Docker Build Status](https://img.shields.io/docker/cloud/build/lewinc/activemq)](https://hub.docker.com/r/lewinc/activemq/) [![Image Size](https://img.shields.io/docker/image-size/lewinc/activemq)](https://hub.docker.com/r/lewinc/activemq/) [![Latest Tag](https://img.shields.io/docker/v/lewinc/activemq?sort=semver)](https://hub.docker.com/r/lewinc/activemq/)


Vanilla ActiveMQ running in docker

Since rmohr/activemq hasn't built a docker image for a few months; here's 5.15.11+ activemq running using
* eclipse-temurin:8-jre
* azul/zulu-openjdk-alpine:8-jre

Since `eclipse-temurin` has arm images, `lewinc/activemq:latest` has been built for arm via github actions, but not the tagged activemq versions, since they're being built docker autobuilds. I suspect that I could build the tags using github actions but since the target here is _developers_; you're always going to be using __latest__ right?

Eventually I'll get bored too, and not update and so the cycle goes on; however the associated github project is here : https://github.com/quotidian-ennui/docker-activemq
