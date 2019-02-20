# Commands

This documentation contains some useful commands i needed to setup this graphql-microservices-example within kubernetes 
(minikube)

##### Make docker commands working with minikube for current terminal session

    eval $(minikube docker-env)

##### Create a secret within kubernetes to be able to pull images from docker hub (or your own private image repository)

    kubectl create secret docker-registry docker-hub-secret --docker-server=https://index.docker.io/v1 --docker-username=renepardon --docker-password="<password goes here>" --docker-email=<email goes here>
    
You could and should add a namespace with the **-n** flag on the `kubectl create secret` command.
*Later you could retrieve those information with*:

    kubectl get secret docker-hub-secret --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode

> Instead of using public docker hub you could use your own private registry

    cd api-gateway && \
    docker build -t renepardon/gme-api:1.0.0 .
    docker login
    docker push renepardon/gme-api:1.0.0

##### Install dependencies

Execute this within `api-gateway/`, `service-1/` and `service-2/` folders:

    helm dep update helm-chart/<helm-name>

#### build the chart and update dependencies before

    helm package --dependency-update helm-chart/<helm-name>

##### Ensure k8s cluster is running

    kubectl cluster-info

##### Install the helm chart within kubernetes (minikube)
    
    helm install --name gme-api helm-chart/gme-api/

If you have configuration issues you can run in dry mode with debug enabled:

    helm install --name gme-api --dry-run --debug helm-chart/gme-api/

Or use the linter if you experience formatting issues:

    helm lint helm-chart/

You would generally not use secrets from within values.yaml files. You should use the **-set** option of `helm install`
instead. E.g.:

    helm install --name gme-api --set mongodb.mongodbRootPassword=<PASSWORD> helm-chart/gme-api/

##### Update the chart within kubernetes 

later on you could simple run an update from within the corresponding service folder

     helm repo update helm-chart/gme-api/

In order to use the same command when installing and upgrading a release, use the following command:

    helm upgrade --install <release name> --values <values file> <chart directory>