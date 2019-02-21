#!/bin/bash

# Ensure that version is adjusted in package.json, helm-chart/templates/Chart.yaml and helm-chart/values.yaml
if [[ -z "$1" ]]; then
    echo "Please provide a version number. Example: 1.1.2\n"
    exit 1
fi

VERSION=$1

docker build -t renepardon/gme-api:${VERSION} --no-cache \
    --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    --build-arg VERSION=${VERSION} \
    ./api-gateway

docker build -t renepardon/gme-service1:${VERSION} --no-cache \
    --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    --build-arg VERSION=${VERSION} \
    ./service-1

docker build -t renepardon/gme-service2:${VERSION} --no-cache \
    --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    --build-arg VERSION=${VERSION} \
    ./service-2