FROM mcr.microsoft.com/openjdk/jdk:21-ubuntu

ARG BASE_URL=https://repo1.maven.org/maven2/org/apache/activemq/apache-activemq
ARG ACTIVEMQ_VERSION=6.1.7
ARG ACTIVEMQ=apache-activemq-$ACTIVEMQ_VERSION
ARG ACTIVEMQ_TGZ=$ACTIVEMQ-bin.tar.gz
ARG ACTIVEMQ_CHECKSUM=$ACTIVEMQ-bin.tar.gz.sha1

ENV ACTIVEMQ_TCP=61616
ENV ACTIVEMQ_AMQP=5672
ENV ACTIVEMQ_STOMP=61613
ENV ACTIVEMQ_MQTT=1883
ENV ACTIVEMQ_WS=61614
ENV ACTIVEMQ_UI=8161
ENV ACTIVEMQ_HOME=/opt/$ACTIVEMQ

COPY xslt/remove-cors.xslt /root

RUN \
  apt-get -y -q update && \
  apt-get install --no-install-recommends -y curl bash xsltproc && \
  rm -rf /var/lib/apt/lists/* && \
  curl -fsSL -o $ACTIVEMQ_TGZ -q "$BASE_URL/$ACTIVEMQ_VERSION/$ACTIVEMQ_TGZ"  && \
  echo "$(curl -fsSL -a -o - $BASE_URL/$ACTIVEMQ_VERSION/$ACTIVEMQ_CHECKSUM)  $ACTIVEMQ_TGZ" >$ACTIVEMQ_CHECKSUM && \
  sha1sum -c $ACTIVEMQ_CHECKSUM && \
  mkdir -p /opt && \
  tar xzf $ACTIVEMQ_TGZ -C /opt && \
  xsltproc -o ./jolokia-access.xml /root/remove-cors.xslt $ACTIVEMQ_HOME/conf/jolokia-access.xml && \
  mv ./jolokia-access.xml $ACTIVEMQ_HOME/conf/jolokia-access.xml && \
  useradd -r -M -d $ACTIVEMQ_HOME activemq && \
  chown -R activemq:activemq $ACTIVEMQ_HOME && \
  chown -h activemq:activemq $ACTIVEMQ_HOME && \
  rm -f $ACTIVEMQ_TGZ $ACTIVEMQ_CHECKSUM /root/remove-cors.xslt

WORKDIR $ACTIVEMQ_HOME
USER activemq

EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI

CMD ["/bin/sh", "-c", "bin/activemq console"]
