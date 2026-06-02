# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile and
# https://github.com/justb4/docker-jmeter
FROM alpine:3.23.4

ARG JMETER_VERSION="5.6.3"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

# Install extra packages
# See https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-272703023
# Change TimeZone TODO: TZ still is not set!
ARG TZ="Europe/Amsterdam"
COPY ./CVE-fix/ /tmp/CVE-fix/
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt \
  && rm -rf /opt/apache-jmeter-${JMETER_VERSION}/lib/ /opt/apache-jmeter-${JMETER_VERSION}/bin/ \
  && cp -r /tmp/CVE-fix/* /opt/apache-jmeter-${JMETER_VERSION}/ \
  && rm -rf /tmp/dependencies /tmp/CVE-fix

RUN chmod +x /opt/apache-jmeter-5.6.3/bin/jmeter \
    /opt/apache-jmeter-5.6.3/bin/*.sh \
    && sed -i 's/\r$//' /opt/apache-jmeter-5.6.3/bin/jmeter \
    /opt/apache-jmeter-5.6.3/bin/jmeter.sh \
    /opt/apache-jmeter-5.6.3/bin/jmeter-server \
    /opt/apache-jmeter-5.6.3/bin/mirror-server \
    /opt/apache-jmeter-5.6.3/bin/mirror-server.sh \
    /opt/apache-jmeter-5.6.3/bin/*.sh

# TODO: plugins (later)
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR	${JMETER_HOME}

ENTRYPOINT ["/entrypoint.sh"]
