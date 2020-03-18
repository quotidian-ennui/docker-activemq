FROM openjdk:8-jre-slim

ARG BASE_URL=https://archive.apache.org/dist/activemq/

ARG ACTIVEMQ_VERSION=5.15.11
ARG ACTIVEMQ=apache-activemq-$ACTIVEMQ_VERSION
ARG ACTIVEMQ_TGZ=$ACTIVEMQ-bin.tar.gz
ARG ACTIVEMQ_SHA512=$ACTIVEMQ-bin.tar.gz.sha512

ENV ACTIVEMQ_TCP=61616 ACTIVEMQ_AMQP=5672 ACTIVEMQ_STOMP=61613 ACTIVEMQ_MQTT=1883 ACTIVEMQ_WS=61614 ACTIVEMQ_UI=8161
ENV ACTIVEMQ_HOME /opt/activemq

# Download and validate checksum; sha512sum will fail if no good.
RUN \
  apt-get -y -q update && \
  apt-get install --no-install-recommends -y curl bash && \
  rm -rf /var/lib/apt/lists/* && \
  curl -fsSL -o $ACTIVEMQ_TGZ -q "$BASE_URL/$ACTIVEMQ_VERSION/$ACTIVEMQ_TGZ"  && \
  curl -fsSL -o $ACTIVEMQ_SHA512 -q "$BASE_URL/$ACTIVEMQ_VERSION/$ACTIVEMQ_SHA512" && \
  sha512sum -c $ACTIVEMQ_SHA512 && \
  mkdir -p /opt && \
  tar xzf $ACTIVEMQ_TGZ -C /opt && \
  ln -s /opt/$ACTIVEMQ $ACTIVEMQ_HOME && \
  useradd -r -M -d $ACTIVEMQ_HOME activemq && \
  chown -R activemq:activemq /opt/$ACTIVEMQ && \
  chown -h activemq:activemq $ACTIVEMQ_HOME && \
  rm -f $ACTIVEMQ_TGZ $ACTIVEMQ_SHA512

WORKDIR $ACTIVEMQ_HOME
USER activemq

EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI

CMD ["/bin/sh", "-c", "bin/activemq console"]