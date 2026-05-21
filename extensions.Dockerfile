FROM alpine/jmeter:5.6.3

# add extensions
COPY ./extensions/lib/ /opt/apache-jmeter-5.6.3/lib
COPY ./extensions/lib/ext/ /opt/apache-jmeter-5.6.3/lib/ext/

# fix CVE
RUN rm -rf /opt/apache-jmeter-5.6.3/lib/ /opt/apache-jmeter-5.6.3/bin/
COPY ./CVE-fix/ /opt/apache-jmeter-5.6.3/

# RUN mkdir /opt/apache-jmeter-5.6.3/tmp/
# COPY ./CVE-fix/ /opt/apache-jmeter-5.6.3/tmp/

# Debug
# ENTRYPOINT ["sleep", "inf"]
