# docker-activemq [![docker-latest](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-latest.yml/badge.svg)](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-latest.yml) [![docker-tag](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-tag.yml/badge.svg)](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-tag.yml) [![Image Size](https://img.shields.io/docker/image-size/lewinc/activemq)](https://hub.docker.com/r/lewinc/activemq/) [![Latest Tag](https://img.shields.io/docker/v/lewinc/activemq?sort=semver)](https://hub.docker.com/r/lewinc/activemq/)


# Vanilla ActiveMQ running in docker

Since rmohr/activemq hasn't built a docker image for a few months; here's 5.15.11+ activemq running using
- eclipse-temurin:11-jre (8-jre for versions <= 5.16.4)
- azul/zulu-openjdk-alpine:11-jre (8-jre for versions <= 5.16.4)
- bellsoft/liberica-openjdk-alpine:11 (8 for versions <= 5.16.4)

 Since `eclipse-temurin` and `liberica-openjdk-alpine` have arm images, those are being built for _linux/amd64_ and _linux/arm64_. zulu-openjdk-alpine doesn't have arm images (yet) for 11-jre so that's still only amd64. Everything should be being built via github actions.

Eventually I'll get bored too, and not update and so the cycle goes on; however the associated github project is here : https://github.com/quotidian-ennui/docker-activemq

## Startup

```
activemq() {
  local AMQ_VER=$1
  local LATEST_TAG="latest-liberica-alpine"
  AMQ_VER=${AMQ_VER:="$LATEST_TAG"}
  local IMAGE="ghcr.io/quotidian-ennui/docker-activemq:$AMQ_VER"
  docker run --name activemq -it --rm -e JDK_JAVA_OPTIONS="-Djetty.host=0.0.0.0" -p127.0.0.1:8161:8161 -p127.0.0.1:61616:61616 \
         -p127.0.0.1:5672:5672 -h activemq.local "$IMAGE"
}

$ activemq
latest-liberica-alpine: Pulling from quotidian-ennui/docker-activemq
Digest: sha256:f03b8e304d323918e0d5593ada6022a29c8fde9ba347d46b91392c90ad6cc6b8
Status: Image is up to date for ghcr.io/quotidian-ennui/docker-activemq:latest-liberica-alpine
ghcr.io/quotidian-ennui/docker-activemq:latest-liberica-alpine
INFO: Loading '/opt/apache-activemq-5.17.4/bin/env'
....
 INFO | Apache ActiveMQ 5.17.4 (localhost, ID:activemq.local-36005-1677501463039-0:1) started
 INFO | For help or more information please see: http://activemq.apache.org
 INFO | ActiveMQ WebConsole available at http://0.0.0.0:8161/
 INFO | ActiveMQ Jolokia REST API available at http://0.0.0.0:8161/api/jolokia/
```

- Note the `-Djetty.host=0.0.0.0` since otherwise jetty.xml may be configured to only listen on 127.0.0.1 which has the tendency break port forwarding; this doesn't matter if you never want to connect via a browser, but will potentially break KEDA.

## Notes

- Removes the strict CORS from jolokia. When I was mucking around with KEDA previously (c. early 2022), CORS was breaking KEDA (this is now fixed in KEDA, but I'm lazy)
- `make diff` | `make update` to use updatecli to update image in the dockerfiles.

