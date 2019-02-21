#!/bin/bash

# Ensure that version is the same as used while calling build-image.sh
if [[ -z "$1" ]]; then
    echo "Please provide a version number. Example: 1.1.2\n"
    exit 1
fi

VERSION=$1

docker login
docker push renepardon/gme-api:${VERSION}
docker push renepardon/gme-service1:${VERSION}
docker push renepardon/gme-service2:${VERSION}