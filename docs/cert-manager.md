# Cert manager

This manifest deploys [cert-manager](https://github.com/cert-manager/cert-manager) in GKE.

## Description

cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates.

It can issue certificates from a variety of supported sources, including Let's Encrypt, HashiCorp Vault, and Venafi as well as private PKI, and it ensures certificates remain valid and up to date, attempting to renew certificates at an appropriate time before expiry.

The full documentation is available on [Cert manager' website](https://cert-manager.io/).

## Pre-requesite

cert-manager require a GCP service account to manage DNS records in the DNS provider. It requires the following permissions:

- dns.resourceRecordSets.create
- dns.resourceRecordSets.delete
- dns.resourceRecordSets.get
- dns.resourceRecordSets.list
- dns.resourceRecordSets.update
- dns.changes.create
- dns.changes.get
- dns.changes.list
- dns.managedZones.list

To create such a service account, you can see the [example given here](https://github.com/padok-team/library-kubernetes-workspace-gke/blob/main/terraform/blueprint-svc/modules/gke/main.tf#L63).

## Check that the component is working

Create a Certificate :

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: test-cert-manager
spec:
  secretName: test-cert-manager-tls
  issuerRef:
    name: letsencrypt-staging
    kind: ClusterIssuer
  # Specify an host for a subdomain you own
  dnsNames:
  - "test-external-dns-main.gcp.library.padok.cloud"
```

Check that your certificate is ready with the command:

```bash
kubectl get certificate -n cert-manager test-cert-manager
```

## Use DNS validation

Add the values file `values.dns.yaml` in addition to the file `values.yaml`. For that, uncomment the right line in [`apps/cert-manager.yaml`](../../apps/cert-manager.yaml).

## Available values for this Chart

All values are described in the [`cert-manager helm chart repository`](https://github.com/cert-manager/cert-manager).
All custom values for this module are explained in the file `values.yaml` and `values.dns.yaml`
