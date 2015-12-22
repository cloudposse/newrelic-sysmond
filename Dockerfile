FROM busybox:ubuntu-14.04
MAINTAINER Erik Osterman "e@osterman.com"

ENV NEWRELIC_VERSION 2.0.3.113
ENV NEWRELIC_LICENSE_KEY -
ENV NEWRELIC_HOSTNAME $(hostname)
ENV NEWRELIC_LOG_LEVEL info

WORKDIR /

ADD https://download.newrelic.com/server_monitor/release/newrelic-sysmond-${NEWRELIC_VERSION}-linux.tar.gz /newrelic-sysmond.tar.gz
RUN tar zvxf /newrelic-sysmond.tar.gz && \
    rm /newrelic-sysmond.tar.gz

WORKDIR /newrelic-sysmond-${NEWRELIC_VERSION}-linux
RUN mv ./nrsysmond.cfg /etc/ && \
    mv ./scripts/nrsysmond-config /bin && \
    mv ./daemon/nrsysmond.x64 /bin/nrsysmond

CMD nrsysmond-config --set license_key=$NEWRELIC_LICENSE_KEY && \
    nrsysmond -c /etc/nrsysmond.cfg -n $NEWRELIC_HOSTNAME -d $NEWRELIC_LOG_LEVEL -l /dev/stdout -f
