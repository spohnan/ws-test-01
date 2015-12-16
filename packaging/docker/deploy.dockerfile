FROM busybox

RUN mkdir /usr/bin /etc/s6

# Copy application
COPY bin/x86_64/ws-test-01 /usr/bin/

# Set up s6 management binaries - http://skarnet.org/software/s6/overview.html
COPY cache/x86_64/s6/bin/* /usr/bin/
COPY cache/x86_64/s6/sbin/* /usr/sbin/

# Set up envconsul client - https://github.com/hashicorp/envconsul
COPY cache/x86_64/envconsul /usr/bin/

RUN chmod -R 755 /usr/bin /usr/sbin

ADD packaging/s6 /etc/s6
RUN find /etc/s6 -type f -exec chmod 755 {} \;

ENTRYPOINT ["/usr/bin/s6-svscan","/etc/s6"]
CMD []
