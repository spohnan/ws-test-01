GIT_COMMIT=$(shell git rev-parse HEAD)
GIT_DIRTY=$(shell test -n "`git status --porcelain`" && echo "+CHANGES" || true)
BUILD_TIMESTAMP=$(shell date -u +%FT%TZ)
OUTPUT_FILE=ws-test-01

all: build

getdeps:
	@echo "Running $@:"
	go get ./...

fmt:
	@echo "Running $@:"
	@GO15VENDOREXPERIMENT=1 gofmt -s -l *.go

lint:
	@echo "Running $@:"
	golint ./...

test:
	@echo "Running $@:"
	go test -v -cover ./...

clean: 
	@echo "Cleaning:"
	@rm -fv bin/$(OUTPUT_FILE)

build: clean getdeps fmt lint test
	go build -a -tags netgo -installsuffix netgo \
    	-ldflags "-X main.GitCommit=$(GIT_COMMIT)$(GIT_DIRTY) -X main.BuildDate=$(BUILD_TIMESTAMP)" \
    	-o bin/$(OUTPUT_FILE)

.PHONY: all clean fmt test build getdeps lint
