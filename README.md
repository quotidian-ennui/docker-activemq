# docker-activemq [![docker-latest](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-latest.yml/badge.svg)](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-latest.yml) [![docker-tag](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-tag.yml/badge.svg)](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-tag.yml) [![Image Size](https://img.shields.io/docker/image-size/lewinc/activemq)](https://hub.docker.com/r/lewinc/activemq/) [![Latest Tag](https://img.shields.io/docker/v/lewinc/activemq?sort=semver)](https://hub.docker.com/r/lewinc/activemq/)


Vanilla ActiveMQ running in docker

Since rmohr/activemq hasn't built a docker image for a few months; here's 5.15.11+ activemq running using
- eclipse-temurin:11-jre (8-jre for versions <= 5.16.4)
- azul/zulu-openjdk-alpine:11-jre (8-jre for versions <= 5.16.4)
- bellsoft/liberica-openjdk-alpine:11 (8 for versions <= 5.16.4)

 Since `eclipse-temurin` and `liberica-openjdk-alpine` have arm images, those are being built for _linux/amd64_ and _linux/arm64_. zulu-openjdk-alpine doesn't have arm images (yet) for 8-jre so that's still only amd64. Everything should be being built via github actions.

Eventually I'll get bored too, and not update and so the cycle goes on; however the associated github project is here : https://github.com/quotidian-ennui/docker-activemq
