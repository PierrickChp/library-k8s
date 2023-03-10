#! /usr/bin/env bash

set -e

# Helpers for readability.
bold=$(tput bold)
red=$(tput setaf 1)
normal=$(tput sgr0)
function _confirm(){
    read -r -p "Continue ? [Y/n] " answer
    if ! [[ "$answer" =~ ^(yes|y|Y|YES)?$ ]];then
        _info "Exiting..."
        exit 1
    fi
}
function _info() {
    echo "${bold}${1}${normal}"
}
function _error() {
    echo "${bold}${red}Error: ${1}${normal}"
}

# Run script from directory where the script is stored.
cd "$( dirname "$0" )"

# Check GKE credentials and project
ACCOUNT=$(gcloud config get-value account)
if [[ $ACCOUNT == "(unset)" ]];then
    gcloud auth login
    ACCOUNT=$(gcloud config get-value account)
fi
_info "ℹ️  Current GCP account is ${ACCOUNT}"
_confirm

_info "ℹ️  Current project is $( gcloud config get project )"
_confirm

# Verify kubecontext
_info "Current context is $(kubectl config current-context)"
if [[ $(kubectl version -o json 2>/dev/null|jq '.serverVersion.gitVersion | contains ("gke")') != "true" ]];then
    _error "❌ You're not using a GKE cluster configuration ! Exiting"
    exit 1
fi
_confirm

# Git Repo SSH key pair
# gcloud check secret exists, if not creates it
GIT_URL=$(git remote get-url origin)
_info "ℹ️  Current GitOps repository is ${GIT_URL}"
_confirm

repository=${GIT_URL}
if [[ -z $( echo "$repository" | grep https ) ]]; then
    # Displays URL
    repository=$( echo $repository | sed -e "s/:/\//g" -e "s/git@/https:\/\//g" )
fi

if ! [[ -n "$( gcloud secrets list | grep argocd-repository-credentials )" ]]; then
    ssh-keygen -t ed25519 -f "/tmp/argocd-repository-credentials" -P ""
    gcloud secrets create argocd-repository-credentials --data-file="/tmp/argocd-repository-credentials"
    gcloud secrets create argocd-repository-credentials-public --data-file="/tmp/argocd-repository-credentials.pub"

    _info "🔑 Add the following deploy key in your repository $repository"
else
    gcloud secrets versions access latest --secret argocd-repository-credentials-public > "/tmp/argocd-repository-credentials.pub"
    _info "🔑 Did you add the deploy key to the $repository ?"
fi
cat "/tmp/argocd-repository-credentials.pub"
_confirm

rm -f "/tmp/argocd-repository-credentials.pub"
rm -f "/tmp/argocd-repository-credentials"

# Install External Secret
# Check values to inject to helm values file
PROJECT_ID=$(gcloud config get project)
GKE_LOCATION=$(gcloud config get compute/region)
CLUSTERNAME=$(kubectl config current-context| cut -d '_' -f4)
_info "ℹ️  Project : $PROJECT_ID"
_info "ℹ️  GKE Location : $GKE_LOCATION"
_info "ℹ️  K8s cluster name : $CLUSTERNAME"
_confirm

# Inject values in helm values file
perl -i -pe"s,projectID: .*,projectID: ${PROJECT_ID},g" helm/external-secrets/values.yaml
perl -i -pe"s,clusterLocation: .*,clusterLocation: ${GKE_LOCATION},g" helm/external-secrets/values.yaml
perl -i -pe"s,clusterName: .*,clusterName: ${CLUSTERNAME},g" helm/external-secrets/values.yaml

# Install external-secrets
_info "🏃‍♂️ Deploying external-secrets"
helm upgrade \
    --install \
    --wait \
    --dependency-update \
    --create-namespace \
    --namespace external-secrets \
    -f helm/external-secrets/values.yaml \
    external-secrets \
    helm/external-secrets
_info "👍 external-secrets Deployment successful."

# Check external-secrets installation
kubectl get ClusterSecretStore secret-store

# Create Repositopry secret
perl -i -pe"s'repoURL: .*'repoURL: ${GIT_URL}'g" helm/argocd/values.yaml
# In this alternative to sed, ' must be the separator or else the character @
# will be interpreted by perl

# Install ArgoCD
_info "🏃‍♂️ Deploying argocd"
helm upgrade \
    --install \
    --wait \
    --dependency-update \
    --create-namespace \
    --namespace argocd \
    -f helm/argocd/values.yaml \
    argocd \
    helm/argocd
_info "👍 argocd Deployment successful."

# Check argocd installation
kubectl get po -n argocd
kubectl get crd applications.argoproj.io
_info "User & password : "
echo -n "admin:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo
_info "🪢  Kubectl port-forward is running in background under PID"
kubectl port-forward svc/argocd-server 8080:80 -n argocd > /dev/null &
python3 -m webbrowser http://localhost:8080
_confirm

# Deploy app of apps manifest
perl -i -pe"s'repoURL: .*'repoURL: ${GIT_URL}'g" apps/*
git add --all
git commit -m 'feat: ArgoCD bootstrap'
git push origin main
kubectl apply -f apps/app-of-apps.yaml
python3 -m webbrowser http://localhost:8080/applications

_info "🙌 Bootstraping of ArgoCD successful."
