#!/bin/bash

set -ex

minikube config set cpus 4
minikube config set memory 4096
minikube config view
minikube delete || true
# virtualbox on windows, hyperkit on mac os, kvm2 on linux
# minikube start --vm-driver ${1-"virtualbox"}
minikube start --vm-driver ${1-"hyperkit"}
