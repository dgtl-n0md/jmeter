FROM alpine/jmeter:5.6.3

# fix CVE: replace lib/ and bin/ with patched versions
RUN rm -rf /opt/apache-jmeter-5.6.3/lib/ /opt/apache-jmeter-5.6.3/bin/
COPY ./CVE-fix/ /opt/apache-jmeter-5.6.3/

# fix permissions and line endings (Docker COPY on Windows may lose executable bits and have CRLF)
RUN chmod +x /opt/apache-jmeter-5.6.3/bin/jmeter \
    /opt/apache-jmeter-5.6.3/bin/*.sh \
    && sed -i 's/\r$//' /opt/apache-jmeter-5.6.3/bin/jmeter \
    /opt/apache-jmeter-5.6.3/bin/jmeter.sh \
    /opt/apache-jmeter-5.6.3/bin/jmeter-server \
    /opt/apache-jmeter-5.6.3/bin/mirror-server \
    /opt/apache-jmeter-5.6.3/bin/mirror-server.sh \
    /opt/apache-jmeter-5.6.3/bin/*.sh
