# Ingress-NGINX Controller

This manifest deploys [Ingress-NGINX Controller](https://github.com/kubernetes/ingress-nginx) in GKE.

## Description

`ingress-nginx` is an Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer.

The full documentation is available on [Ingress-NGINX's website](https://kubernetes.github.io/ingress-nginx/).

## Pre-requesite

If you want to use a static IP address for the controller, you need to [reserve a static IP address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address). If you want to use a L7 load balancer, this IP address needs to be a [global](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) one.

## Create an Ingress resource

If you want an Ingress to target one of your service using Ingress-NGINX Controller, you only need to create a simple [Ingress resource](https://kubernetes.io/fr/docs/concepts/services-networking/ingress/).
Do not forget to specify the ingressClass attribute in the ingress.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  ingressClassName: nginx
```

## Check that the component is working

Create an Ingress resource that targets a service and request it with `curl`.

## Use a layer 7 load balancer

1. Create a certificate and set its name in the `values.L7.yaml` file.
1. Create a [modern TLS policy like this one](https://github.com/padok-team/library-kubernetes-workspace-gke/blob/main/terraform/blueprint-svc/main.tf#L22).
2. Use the value file `values.L7.yaml` in addition the file `values.yaml`. For that, uncomment the right line in [`apps/ingress-nginx.yaml`](../../apps/ingress-nginx.yaml).

## Available values for this Chart

All values are described in the [`ingress-nginx helm chart repository`](https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml).
Specific values to the Chart provided by Padok are documented in the `values.yaml` and in the `values.L7.yaml` files.
