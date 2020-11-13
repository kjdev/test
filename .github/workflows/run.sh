#!/bin/sh -e

apk --no-cache upgrade
apk --no-cache add autoconf gcc libtool make musl-dev

phpize
./configure
make
make test
