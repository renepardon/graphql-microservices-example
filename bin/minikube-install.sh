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

echo "Executing curl $(minikube ip):"
curl $(minikube ip)
echo "\n"

watch -n 1 'kubectl get pods --all-namespaces'