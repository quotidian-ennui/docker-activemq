FROM azul/zulu-openjdk-alpine:11-jre

ARG BASE_URL=https://repository.apache.org/content/repositories/releases/org/apache/activemq/apache-activemq/
ARG ACTIVEMQ_VERSION=5.17.2
ARG ACTIVEMQ=apache-activemq-$ACTIVEMQ_VERSION
ARG ACTIVEMQ_TGZ=$ACTIVEMQ-bin.tar.gz
ARG ACTIVEMQ_CHECKSUM=$ACTIVEMQ-bin.tar.gz.sha1

ENV ACTIVEMQ_TCP=61616 ACTIVEMQ_AMQP=5672 ACTIVEMQ_STOMP=61613 ACTIVEMQ_MQTT=1883 ACTIVEMQ_WS=61614 ACTIVEMQ_UI=8161
ENV ACTIVEMQ_HOME /opt/$ACTIVEMQ

COPY xslt/remove-cors.xslt /root

# Download and validate checksum; sha1sum will fail if no good.
RUN \
  apk add --no-cache --update ca-certificates bash curl libxslt && \
  adduser -S activemq && \
  curl -fsSL -o $ACTIVEMQ_TGZ -q "$BASE_URL/$ACTIVEMQ_VERSION/$ACTIVEMQ_TGZ"  && \
  echo "$(curl -fsSL -a -o - $BASE_URL/$ACTIVEMQ_VERSION/$ACTIVEMQ_CHECKSUM)  $ACTIVEMQ_TGZ" >$ACTIVEMQ_CHECKSUM && \
  sha1sum -c $ACTIVEMQ_CHECKSUM && \
  mkdir -p /opt && \
  tar xzf $ACTIVEMQ_TGZ -C /opt && \
  xsltproc -o ./jolokia-access.xml /root/remove-cors.xslt $ACTIVEMQ_HOME/conf/jolokia-access.xml && \
  mv ./jolokia-access.xml $ACTIVEMQ_HOME/conf/jolokia-access.xml && \
  chown -R activemq $ACTIVEMQ_HOME && \
  chown -h activemq $ACTIVEMQ_HOME && \
  rm -f $ACTIVEMQ_TGZ $ACTIVEMQ_CHECKSUM /root/remove-cors.xslt

WORKDIR $ACTIVEMQ_HOME
USER activemq

EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI

CMD ["/bin/sh", "-c", "bin/activemq console"]