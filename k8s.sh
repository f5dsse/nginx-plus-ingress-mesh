#!/bin/bash

# Install k3s
export INSTALL_K3S_EXEC="server --no-deploy traefik"
curl -sfL https://get.k3s.io | sh -s -
mkdir $HOME/.kube
sudo cat /etc/rancher/k3s/k3s.yaml > $HOME/.kube/config
echo "export KUBECONFIG=$HOME/.kube/config" > $HOME/.profile

# Instal nginx-meshctl
wget --content-disposition https://downloads08.f5.com/esd/download.sv?loc=downloads08.f5.com/downloads/5b3d6efe-5cbd-4912-9626-efe44a30ef69/nginx-meshctl_linux.gz
gunzip nginx-meshctl_linux.gz

# Deploy NSM
nginx-meshctl deploy \
    --prometheus-address "prometheus.nsm-monitoring.svc:9090" \
    --telemetry-exporters "type=otlp,host=otel-collector.nsm-monitoring.svc,port=4317" \
    --telemetry-sampler-ratio 1 \
    --disable-auto-inject \
    --enabled-namespaces default

kubectl create namespace nginx-ingress
kubectl apply -f nginx-plus-ingress
kubectl apply -f nginx-plus-ingress
kubectl create namespace nsm-monitoring
kubectl apply -f nsm-monitoring
kubectl apply -f bookinfo
