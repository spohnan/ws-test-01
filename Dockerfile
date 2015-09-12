FROM tianon/true
COPY bin/ws-test-01 /
ENTRYPOINT ["/ws-test-01"]