#!/bin/bash

### Check for sudo/root
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script with root permission"
  exit
fi

### Only attempt to install minikube if it's not already installed
if ! [[ -x "$(command -v minikube)" ]]; then
  unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     machine=Linux;;
        Darwin*)    machine=Mac;;
        *)          machine="UNKNOWN:${unameOut}"
    esac

    # Installation of minikube
    if [[ "$(machine)" == "Mac" ]]; then
        curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
    elif [[ "$(machine)" == "Linux" ]]; then
        curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    else
        echo "Please install on Mac/Linux"
        exit
    fi

    chmod +x minikube
    sudo mv minikube /usr/local/bin
fi

### Now let's install Helm if not already done
if ! [[ -x "$(command -v helm)" ]]; then
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
    chmod 700 get_helm.sh
    sh ./get_helm.sh
fi

# Default initialization of helm/tiller and update the repo for fresh charts list
helm init --wait
# helm repo update
# kubectl --namespace=kube-system get pods

# TBD: helm install --values ./kubernetes/traefik-values.yaml stable/traefik
# TBD:kubectl apply -f ./kubernetes/traefik-ui.yaml

### Create /etc/hosts entry for traefik ui if not already exists
# TBD: if ! grep -rnie "traefik-ui.minikube" /etc/hosts; then
# TBD:     echo "$(minikube ip) traefik-ui.minikube" | sudo tee -a /etc/hosts
# TBD: fi

### RBAC minimal configuration
# TBD: kubectl create -f kubernetes/namespaces.yaml
# > kubectl get namespaces
# TBD: kubectl create -f kubernetes/tiller-sa.yaml
# > kubectl get sa --all-namespaces
# TBD: kubectl create -f kubernetes/helm-sa.yaml
# > kubectl -n staging get sa
# TBD: kubectl create -f kubernetes/tiller-roles.yaml
# TBD: kubectl create -f kubernetes/tiller-rolebindings.yaml
# > kubectl get roles.rbac.authorization.k8s.io,rolebindings.rbac.authorization.k8s.io -n development
# TBD: kubectl create -f kubernetes/helm-clusterrole.yaml
# TBD: kubectl create -f kubernetes/helm-clusterrolebinding.yaml
# > kubectl get clusterroles.rbac.authorization.k8s.io,clusterrolebindings.rbac.authorization.k8s.io
# TBD: helm init --service-account tiller --tiller-namespace development

### Find the secret associated with the Service Account
# TBD: SECRET=$(kubectl -n staging get sa helm -o jsonpath='{.secrets[].name}')
# Retrieve the token from the secret and decode it
# TBD: TOKEN=$(kubectl get secrets -n staging $SECRET -o jsonpath='{.data.token}' | base64 -D)
# Retrieve the CA from the secret, decode it and write it to disk
# TBD: kubectl get secrets -n staging $SECRET -o jsonpath='{.data.ca\.crt}' | base64 -D > ca.crt
# Retrieve the current context
# TBD: CONTEXT=$(kubectl config current-context)
# Retrieve the cluster name
# TBD: CLUSTER_NAME=$(kubectl config get-contexts $CONTEXT --no-headers=true | awk '{print $3}')
# Retrieve the API endpoint
# TBD: SERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name == \"${CLUSTER_NAME}\")].cluster.server}")
# Set up variables
# TBD: KUBECONFIG_FILE=config USER=helm CA=ca.crt
# Set up config
# TBD: kubectl config set-cluster $CLUSTER_NAME \
# TBD:     --kubeconfig=$KUBECONFIG_FILE \
# TBD:     --server=$SERVER \
# TBD:     --certificate-authority=$CA \
# TBD:     --embed-certs=true
# Set token credentials
# TBD: kubectl config set-credentials \
# TBD:     $USER \
# TBD:     --kubeconfig=$KUBECONFIG_FILE \
# TBD:     --token=$TOKEN
# Set context entry
# TBD: kubectl config set-context \
# TBD:     $USER \
# TBD:     --kubeconfig=$KUBECONFIG_FILE \
# TBD:     --cluster=$CLUSTER_NAME \
# TBD:     --user=$USER
# Set the current-context
# TBD: kubectl config use-context $USER \
# TBD:     --kubeconfig=$KUBECONFIG_FILE

### Install grafana and prometheus into development namespace
helm install \
    --name prometheus \
    stable/prometheus \
    --tiller-namespace development \
    --kubeconfig config \
    --namespace development \
    --set rbac.create=false

helm install --name grafana \
    stable/grafana \
    --tiller-namespace development \
    --kubeconfig config \
    --namespace development \
    --set rbac.pspEnabled=false \
    --set rbac.create=false

cd helm-chart/umbrella/ && \
    helm dep update && \
    helm delete --purge umbrella && \
    helm lint . && \
    helm install .

### Finally, get the pods list and curl the cluster ip
kubectl get pods --all-namespaces

### Wait for pods to become available
for i in {0..20}; do echo -ne "Wait $i of 20 seconds before continuing"'\r'; sleep 1; done; echo

kubectl get pods --all-namespaces

echo "Executing curl $(minikube ip):"
curl $(minikube ip)
echo "\n"