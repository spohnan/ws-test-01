FROM tianon/true
COPY bin/x86_64/ws-test-01 /
ENTRYPOINT ["/ws-test-01"]