# ArgoCD bootstraping on GKE

This section explains how to deploy ArgoCD for the first time.

## Context

Our target architecture is for ArgoCD to manage every component deployed in the
cluster, including ArgoCD itself. Once ArgoCD is deployed, it uses the content
of this repository to deploy everything.

## Target Architecture

![archi](assets/Archi.png)

### Applications deployed in bootstrap

- [x] ArgoCD
- [x] External Secrets
- [x] NGINX Ingress Controller
- [x] External DNS
- [x] CertManager
- [x] OAuth2 Proxy
- [x] Prometheus
- [x] Grafana
- [ ] Calico
- [x] Kyverno
- [ ] ArgoCD Image Updater
- [ ] Loki

## Requirements

- `bash`
- `gcloud`
- `git`
- `helm`
- `kubectl`
- `openssh`
- `perl`
- `python3`
- Have a kubernetes cluster up (ie. `kubectl get nodes` works)
- Be connected to a GCP project with the region (resp. zone) set to the region of your cluster (resp. zone)

## Instructions

1. Create your own GitOps repository with these files

    > After you created your own repository on the remote,
    > you can **clone it** and then **copy-paste** the files in it.
    > Or, you can **change the remote origin** of this one.

2. Just launch the shell script named `bootstrap.sh` and follow the step

## What does the bootstrap do ?

1. It checks you gcloud and kube configs
2. If it does not exist yet, it creates a SSH key pair and uplaod the values to GCP Secret Manager
   1. MANUAL : It asks you to upload the public key as a Deploy key in your repo
3. It installs external-secrets with a ClusterSecretStore
4. It installs argocd with git repo credentials
5. It deploys the app of apps which manage all apps (including argocd and external-secrets)

## Repository structure

```
.
├── apps
│   ├── app-of-apps.yaml
│   ├── argocd.yaml
│   │   ...
│   └── <myapp>.yaml
├── assets
│   └── Archi.png
├── docs
│   ├── argocd.md
│   │   ...
│   └── <myapp>.md
├── helm
│   ├── argocd
│   │   ├── templates
│   │   ├── Chart.yaml
│   │   ├── README.md
│   │   │   ...
│   │   └── values.yaml
│   │   ...
│   └── <myapp>
│       ├── templates
│       ├── Chart.yaml
│       ├── README.md
│       │   ...
│       └── values.yaml
├── boostrap.sh
│   ...
└──  README.md
```

Directory details:

- `apps`: Contains all Argo CD applications, watching application manifests in the `helm` directory.
    - `app-of-apps.yaml`: The app of apps application watching the `apps` directory.
    - `argocd.yaml`: The app deploying ArgoCD.
- `docs`: Contains symbolic links to documentation files read by Backstage.
- `helm`: Contains all helm charts of applications deployed. Each chart has a `README.md` file describing the component deployed and how to use it.
    - `argocd`: ArgoCD helm chart.
- `boostrap.sh`: The boostrap script that automatically deploys ArgoCD and applications in your cluster.
