# docker-activemq [![docker-latest](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-latest.yml/badge.svg)](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-latest.yml) [![docker-tag](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-tag.yml/badge.svg)](https://github.com/quotidian-ennui/docker-activemq/actions/workflows/docker-tag.yml) [![Image Size](https://img.shields.io/docker/image-size/lewinc/activemq)](https://hub.docker.com/r/lewinc/activemq/) [![Latest Tag](https://img.shields.io/docker/v/lewinc/activemq?sort=semver)](https://hub.docker.com/r/lewinc/activemq/)


# Vanilla ActiveMQ running in docker

Since rmohr/activemq hasn't built a docker image for a few months; here's 5.15.11+ activemq running using
- eclipse-temurin:25-jre (21-jre <= 6.1.7, 11-jre < 6.0.0, 8-jre <= 5.16.4)
- azul/zulu-openjdk-alpine:25-jre (21-jre <= 6.1.7, 11-jre < 6.0.0, 8-jre <= 5.16.4)
- bellsoft/liberica-openjdk-alpine:25 (21-jre <= 6.1.7, 11 < 6.0.0, 8 <= 5.16.4)
- ~~mcr.microsoft.com/openjdk/jdk:21-ubuntu~~ (this isn't built automatically)

 Since `eclipse-temurin` and `liberica-openjdk-alpine` have arm images, those are being built for _linux/amd64_ and _linux/arm64_. ~~zulu-openjdk-alpine doesn't have arm images (yet) for 11-jre so that's still only amd64~~ (`zulu-openjdk-alpine` now has arm64/v8). Everything should be being built via github actions.

Eventually I'll get bored too, and not update and so the cycle goes on; however the associated github project is here : https://github.com/quotidian-ennui/docker-activemq

> Note that [https://hub.docker.com/r/apache/activemq-classic](https://hub.docker.com/r/apache/activemq-classic/tags) now exists which means that this image will die a slow death.
> I've left it as-is because it takes very little actual effort on my part (updatecli + tag); I anticipate that 5.19.x may well be the last release(s) and it shouldn't really matter that much since you won't have been using it for anything other than testing because it's not hardened or productionized in any fashion (right?).
> You might continue using this image because the apache 5.18.2 doesn't have an arm64 image (yet) and you're running on a raspberry pi or something.

## Startup

```
activemq() {
  local AMQ_VER=$1
  local LATEST_TAG="latest-liberica-alpine"
  AMQ_VER=${AMQ_VER:="$LATEST_TAG"}
  local IMAGE="ghcr.io/quotidian-ennui/docker-activemq:$AMQ_VER"
  docker run --name activemq -it --rm -e JDK_JAVA_OPTIONS="-Djetty.host=0.0.0.0" \
        -p127.0.0.1:8161:8161 -p127.0.0.1:61616:61616 \
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


## Notes

> These are things you're going to wish you knew eventually, so I'm going to tell you now.

- Note the `-Djetty.host=0.0.0.0` since otherwise jetty.xml may be configured to only listen on 127.0.0.1 which has the tendency to break port forwarding; this doesn't matter if you never want to connect via a browser, but will potentially break KEDA.
- `make diff` | `make update` to use updatecli to update the image in the dockerfiles.
- _5.18.0 brings JMS 2.0 support and also an additional `activemq-client-jakarta` jar for (optional) inclusion in your dependency tree_. The days of the `javax.jms` package are numbered and counting down; it will all come bubbling up and come to a head (with much wailing and gnashing of teeth on stackoverflow) when Spring 6.0 reaches GA (since `jakarta.*` packages will be a requirement for that, much like TPM 2.0 for Windows 11).
- Removes the strict CORS from jolokia. When I was mucking around with KEDA previously (c. early 2022), CORS was breaking KEDA (this is now fixed in KEDA, but this might still be arbitrarily useful to be disabled)
