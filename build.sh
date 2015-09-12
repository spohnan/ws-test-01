#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

info() { echo -e "\033[36m$@\033[m"; }     # light blue
success() { echo -e "\033[32m$@\033[m"; }  # green
warn() { echo -e "\033[33m$@\033[m"; }     # yellow
error() { echo -e "\033[31m$@\033[m"; }    # red

OUTPUT_FILE=ws-test-01
rm -f bin/$OUTPUT_FILE

# Get the git commit and other build information we'll compile into the program
GIT_COMMIT=$(git rev-parse HEAD)
GIT_DIRTY=$(test -n "`git status --porcelain`" && echo "+CHANGES" || true)
BUILD_TIMESTAMP=$(date -u +%FT%TZ)

info "--> Installing dependencies..."
go get ./...

info "--> Formatting..."
go fmt

info "--> Vetting..."
go vet

info "--> Testing..."
go test -v -cover ./... ; if [ $? -eq 0 ]; then
	success "Tests Passing"
else
	error "Tests fail, exiting"
	exit 
fi

info "--> Building..."
if [ ! -x $1 ]; then
	export GOOS=$1  # If calling from dockerize.sh we're running tests natively but probably crosscompiling
fi
go build -a -tags netgo -installsuffix netgo \
    -ldflags "-X main.GitCommit=${GIT_COMMIT}${GIT_DIRTY} -X main.BuildDate=${BUILD_TIMESTAMP}" \
    -v \
    -o bin/$OUTPUT_FILE
