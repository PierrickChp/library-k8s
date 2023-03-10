# External Secrets

This manifest deploys [external-secrets](https://github.com/external-secrets/external-secrets) in GKE.

## Description

External Secrets is a Kubernetes operator that integrates external secret management systems like AWS Secrets Manager, HashiCorp Vault, Google Secrets Manager, Azure Key Vault and many more. The operator reads information from external APIs and automatically injects the values into a Kubernetes Secret.

The full documentation is available on [External Secrets' website](https://external-secrets.io/v0.5.9/).

## Pre-requesite

External Secrets require a GCP service account with the role `roles/secretmanager.secretAccessor` in order to access secrets stored in the Secrets Manager. To create such a service account, you can see the [example given in the starter GKE](https://github.com/padok-team/terraform-google-starter-gke/blob/main/blueprint-svc/modules/gke/main.tf#L14).

## ExternalSecret resource

External Secrets provides the ExternalSecret resource to access external secrets and create kubernetes secret with their content. The resource is described in the [documentation](https://external-secrets.io/v0.5.9/spec/#external-secrets.io/v1beta1.ExternalSecret).

## Check that the component is working

Create an ExternalSecret resource and check its status with :

```bash
kubectl get externalsecret <my_secret>
```

If the component is working correctly, the status of your ExternalSecret should be `SecretSynced`.

## Available values for this Chart

All values are described in the [`external-secrets helm chart repository`](https://github.com/external-secrets/external-secrets/blob/main/deploy/charts/external-secrets/values.yaml).
