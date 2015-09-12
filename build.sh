#!/bin/bash

# Navigate into the directory containing this script
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

info() { echo -e "\033[36m$@\033[m"; }     # light blue
success() { echo -e "\033[32m$@\033[m"; }  # green
warn() { echo -e "\033[33m$@\033[m"; }     # yellow
error() { echo -e "\033[31m$@\033[m"; }    # red

# Name of the binary output file
OUTPUT_FILE=ws-test-01

# Remove the old binary
rm -f bin/$OUTPUT_FILE

# Get the git commit
GIT_COMMIT=$(git rev-parse HEAD)
GIT_DIRTY=$(test -n "`git status --porcelain`" && echo "+CHANGES" || true)

# Other build information we'll compile into the program

BUILD_TIMESTAMP=$(date -u +%FT%TZ)

# Install dependencies
info "--> Installing dependencies..."
go get ./...

info "--> Formatting..."
go fmt

info "--> Vetting..."
go vet

# Test
info "--> Testing..."
go test -v -cover ./... ; if [ $? -eq 0 ]; then
	success "Tests Passing"
else
	error "Tests fail, exiting"
	exit 
fi

# Build!
info "--> Building..."
export GOOS=linux 
go build -a -tags netgo -installsuffix netgo \
    -ldflags "-X main.GitCommit=${GIT_COMMIT}${GIT_DIRTY} -X main.BuildDate=${BUILD_TIMESTAMP}" \
    -v \
    -o bin/$OUTPUT_FILE
