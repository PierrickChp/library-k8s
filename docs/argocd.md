# Argo CD

This manifest deploys [Argo CD](https://github.com/argoproj/argo-cd) in GKE.

## Description

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes. It reads helm charts in remote repositories and deploys them in kubernetes clusters.

The full documentation is available on [Argo CD' website](https://argo-cd.readthedocs.io/en/stable/).

## Pre-requesite

- A secret `argocd-repository-credentials` in GCP Secret Manager with a deploy key for your git repository.

## Check that the component is working

Add an application to deploy ArgoCD with ArgoCD. Check that everything works fine by port forwarding on ArgoCD server service:

```bash
kubectl port-forward -n argocd svc/argocd-server 8080:80
```

The admin credentials to log in can be retrieved with the following command:

```bash
kubectl get secrets -n argocd argocd-initial-admin-secret -o yaml | yq '.data.password' | base64 -d
```

## Make Argo reachable from the internet

Add the values file `values.ingress.yaml` in addition to the file `values.yaml`. For that, uncomment the right line in [`apps/argocd.yaml`](../../apps/argocd.yaml).

## Use IAP to authenticate on ArgoCD

Add the values file `values.iap.yaml` in addition to the files `values.ingress.yaml` and `values.yaml`. For that, uncomment the right line in [`apps/argocd.yaml`](../../apps/argocd.yaml).

## Available values for this Chart

All values are described in the [`argo-cd helm chart repository`](https://github.com/argoproj/argo-helm/blob/master/charts/argo-cd/values.yaml).
