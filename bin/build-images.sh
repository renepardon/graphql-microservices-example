#!/bin/bash

# Ensure that version is adjusted in package.json, helm-chart/templates/Chart.yaml and helm-chart/values.yaml
if [[ -z "$1" ]]; then
    echo "Please provide a version number. Example: 1.1.2\n"
    exit 1
fi

VERSION=$1

docker build -t renepardon/gme-api:${VERSION} ./api-gateway --no-cache
docker build -t renepardon/gme-service1:${VERSION} ./service-1 --no-cache
docker build -t renepardon/gme-service2:${VERSION} ./service-2 --no-cache