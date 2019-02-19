# GraphQL Microservices example with Remote Stitching using NodeJS and ExpressJS

This projects serves as an example project for Remote Stitching GraphQL instances together through a central GraphQL 
API. This is a great practice for easily connecting large nets of microservices and is easily maintainable.

> NOTE: In a real world project the `api-gateway`, `service-1` and `service-2` would be in it's own SCM repositories.

# Usage

## General

    npm install-all

Go into every service (new terminal windows) and run `npm run start`. When both services are running, start the API the 
same way. It's optimized for running in docker. So the endpoints within `api-gateway/server.js` need to be adjusted to 
*localhost:8082* and *localhost:8083* if you want to run it without docker.

## Docker

First create the `gme` network if it doesn't already exist. Then start all the services and the API gateway.

    docker network create gme
    docker-compose up -d

## kubernetes

### Docker commands for minikube

Make docker commands working with minikube for current terminal session

    eval $(minikube docker-env)

### minikube

    kubectl create secret docker-registry docker-hub-secret --docker-server=https://index.docker.io/v1 --docker-username=renepardon --docker-password="<password goes here>" --docker-email=<email goes here>
    
You could and should add a namespace with the **-n** flag on the `kubectl create secret` command.
Later you could retrieve those information with:

    kubectl get secret docker-hub-secret --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode

> Instead of using public docker hub you could and should use your own private registry

    cd api-gateway && \
    docker build -t renepardon/gme-api:1.0.0 . && \
    docker login

    docker push renepardon/gme-api:1.0.0

Install dependencies

    helm dep update helm-chart/<helm-name>

Ensure k8s cluster is running

    kubectl cluster-info

Install the helm chart
    
    helm install --name gme-api helm-chart/gme-api/

If you have configuration issues you can run in dry mode with debug enabled

    helm install --name gme-api --dry-run --debug helm-chart/gme-api/

Or use the linter if you experience formatting issues

    helm lint helm-chart/

You would generally not use secrets from within values.yaml files. You should use the **-set** option of `helm install`
instead. E.g.

    helm install --name gme-api --set mongodb.mongodbRootPassword=<PASSWORD> helm-chart/gme-api/

To update the chart within kubernetes later on you could simple run an update from within the corresponding service 
folder

     helm repo update helm-chart/gme-api/

In order to use the same command when installing and upgrading a release, use the following command:

    helm upgrade --install <release name> --values <values file> <chart directory>
