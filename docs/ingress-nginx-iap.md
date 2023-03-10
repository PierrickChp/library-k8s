# IAP Ingress-NGINX Controller

This manifest deploys [Ingress-NGINX Controller](https://github.com/kubernetes/ingress-nginx) in GKE with support for Identity Aware Proxy (IAP).

## Description

`ingress-nginx` is an Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer. IAP used on the load balancer spawned by the Ingress Controller help authenticate and authorize requests to protected resources.

## Pre-requesite

An IAP application need to be configured for the Ingress Controller. For that, create the app with Terraform and add its credentials in the secret manager (an example is given [here](https://github.com/padok-team/library-kubernetes-workspace-gke/blob/main/terraform/blueprint-svc/modules/iap-oauth-client/main.tf)).

If you want to use a static IP address for the controller, you need to [reserve a static global IP address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address).

Don't forget to change the `hosts` property in the values file and to add the right DNS record to target the IAP load balancer.

## Create an IAP Ingress resource

To use an IAP Ingress, only specify its ingress class in the ingress resource.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-iap-ingress
spec:
  ingressClassName: iap
```

## Check that the component is working

Create an IAP Ingress resource that targets a service and request it with `curl`.

## Available values for this Chart

All values are described in the [`ingress-nginx helm chart repository`](https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml).
Specific values to the Chart provided by Padok are documented in the `values.yaml` file.
