#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

./build.sh linux
docker build -t spohnan/ws-test-01 .
docker run --rm -it -p 8080:8080 spohnan/ws-test-01
