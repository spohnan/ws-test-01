GIT_COMMIT=$(shell git rev-parse HEAD)
GIT_DIRTY=$(shell test -n "`git status --porcelain`" && echo "+CHANGES" || true)
BUILD_TIMESTAMP=$(shell date -u +%FT%TZ)
OUTPUT_FILE=ws-test-01

export GO15VENDOREXPERIMENT=1

# Local targets
# -------------------------------------------------------

all: build
.PHONY: all

clean: 
	@echo "Cleaning:"
	@rm -frv bin/*
.PHONY: clean

getdeps:
	@echo "Running $@:"
	go get github.com/Masterminds/glide
	go get github.com/golang/lint/golint
	go get golang.org/x/tools/cmd/vet
	glide up
.PHONY: getdeps

fmt: getdeps
	@echo "Running $@:"
	gofmt -s -l *.go
.PHONY: fmt

# golint doens't like the path produced by glide novendor
lint:
	@echo "Running $@:"
	for dir in $(shell glide novendor) ; do \
		golint "$$dir"; \
	done
.PHONY: lint

vet:
	@echo "Running $@:"
	go vet $(shell glide novendor)
.PHONY: vet

test: getdeps
	@echo "Running $@:"
	go test -cover $(shell glide novendor)
.PHONY: test

build: clean getdeps fmt lint vet test
	go build -a -tags netgo -installsuffix netgo \
    	-ldflags "-X main.GitCommit=$(GIT_COMMIT)$(GIT_DIRTY) -X main.BuildDate=$(BUILD_TIMESTAMP)" \
    	-o bin/$(OUTPUT_FILE)
.PHONY: build

run: build
	bin/$(OUTPUT_FILE)
.PHONY: run

# Docker targets
# -------------------------------------------------------

docker-build: clean
	mkdir bin/x86_64
	docker build --rm -t build-temp -f packaging/docker/build.dockerfile .
	docker run --rm -v $(shell pwd)/bin/x86_64:/go/src/github.com/spohnan/ws-test-01/bin build-temp
	docker rmi -f build-temp
	docker build -t spohnan/ws-test-01 -f packaging/docker/deploy.dockerfile .
.PHONY: docker-build

docker-run: docker-build
	docker run --rm -it -p 8080:8080 spohnan/ws-test-01
.PHONY: docker-run
