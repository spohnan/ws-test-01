GIT_COMMIT=$(shell git rev-parse HEAD)
GIT_DIRTY=$(shell test -n "`git status --porcelain`" && echo "+CHANGES" || true)
BUILD_TIMESTAMP=$(shell date -u +%FT%TZ)
OUTPUT_FILE=ws-test-01
CONSUL_IP=$(shell ip addr show eth0 | grep "inet " | awk '{ print $$2 }' | cut -d/ -f1 )
CONSUL_URL=https://github.com/hashicorp/envconsul/releases/download/v0.6.0/envconsul_0.6.0_linux_amd64.zip
S6_URL=https://github.com/just-containers/skaware/releases/download/v1.17.0/s6-2.2.4.0-linux-amd64-bin.tar.gz
BIN=bin/x86_64
CACHE=cache/x86_64

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
	for dir in $(shell export GO15VENDOREXPERIMENT=1; glide novendor) ; do \
		golint "$$dir"; \
	done
.PHONY: lint

vet:
	@echo "Running $@:"
	go vet $(shell export GO15VENDOREXPERIMENT=1; glide novendor)
.PHONY: vet

test: getdeps
	@echo "Running $@:"
	go test -cover $(shell export GO15VENDOREXPERIMENT=1; glide novendor)
	go test -cover $(glide novendor)
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

# Bash scripting used to download. Comment this out and pre-populate the
# cache directory yourself if you don't want to do it this way
download-deps:
	mkdir -p $(CACHE)/s6
	if [ ! -f $(CACHE)/envconsul ]; then \
		wget -O $(CACHE)/envconsul.zip $(CONSUL_URL); \
		unzip -d $(CACHE) $(CACHE)/envconsul.zip; \
		rm -f $(CACHE)/envconsul.zip; \
	else \
	    echo "envconsul binary cached"; \
	fi
	if [ ! -d $(CACHE)/s6/bin ]; then \
        wget -O $(CACHE)/s6.tar.gz $(S6_URL); \
        tar -xzf $(CACHE)/s6.tar.gz -C $(CACHE)/s6 ;\
        rm -f $(CACHE)/s6.tar.gz; \
    else \
        echo "s6 binaries cached"; \
    fi

docker-build: download-deps
	mkdir -p bin/x86_64
	if [ ! -f $(BIN)/$(OUTPUT_FILE) ]; then \
	    docker build --rm -t build-temp -f packaging/docker/build.dockerfile . ; \
	    docker run --rm -v $(shell pwd)/bin/x86_64:/go/src/github.com/spohnan/ws-test-01/bin build-temp ; \
	    docker rmi -f build-temp ; \
	else \
	    echo "$(BIN)/$(OUTPUT_FILE) cached"; \
	fi
	docker build -t spohnan/ws-test-01 -f packaging/docker/deploy.dockerfile .
.PHONY: docker-build

docker-build-clean: clean docker-build
.PHONY: docker-build-clean

docker-run: docker-build
	docker run --rm -it -p 8080:8080 spohnan/ws-test-01
.PHONY: docker-run

docker-run-consul: docker-build
	docker run --rm -it -e "CONSUL=$(CONSUL_IP):8500" -p 8080:8080 spohnan/ws-test-01
.PHONY: docker-run-consul
