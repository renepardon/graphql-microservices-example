#!/bin/bash

helm del $(helm ls -q)
cd helm-chart/umbrella/
helm dep update
helm delete --purge umbrella
helm lint . && \
helm install --dep-up .
cd ../..
