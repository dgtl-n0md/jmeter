FROM alpine/jmeter:5.6.3

COPY ./extensions/lib/* /opt/apache-jmeter-5.6.3/lib
COPY ./extensions/lib/ext/* /opt/apache-jmeter-5.6.3/lib/ext/

# Debug
# ENTRYPOINT ["sleep", "inf"]
