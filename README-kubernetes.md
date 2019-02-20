
# Overview

- Install Minikube
    - Install kubectl according to the instructions in [Install and Set Up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
    
    
    brew install docker-machine-driver-hyperkit
    sudo chown root:wheel /usr/local/opt/docker-machine-driver-hyperkit/bin/docker-machine-driver-hyperkit
    sudo chmod u+s /usr/local/opt/docker-machine-driver-hyperkit/bin/docker-machine-driver-hyperkit

    brew cask install minikube

- Install Helm
    - brew install kubernetes-helm
- Install Traefik-Ingress-Controller
- Configure RBAC (access controll)
- Install chart(s):
- Enjoy

## CI/CD

Use Helmsman/Helm for CI/CD.

> tbc
