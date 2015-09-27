FROM golang:1.5

RUN mkdir -p /go/src/github.com/spohnan/ws-test-01
COPY . /go/src/github.com/spohnan/ws-test-01
WORKDIR /go/src/github.com/spohnan/ws-test-01
ENTRYPOINT ["/usr/bin/make"]
