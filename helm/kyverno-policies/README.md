# Kyverno

This manifest deploys [`kyverno-policies`](https://github.com/kyverno/kyverno/tree/main/charts/kyverno-policies) in GKE.

## Description

This chart contains Kyverno's implementation of the Kubernetes Pod Security Standards (PSS) as documented at https://kubernetes.io/docs/concepts/security/pod-security-standards/ and is a Helm packaged version of the policies found at https://github.com/kyverno/policies/tree/main/pod-security. The goal of the PSS controls is to provide a good starting point for general Kubernetes cluster operational security. These controls are broken down into two categories, Baseline and Restricted. Baseline policies implement the most basic of Pod security controls while Restricted implements more strict controls. Restricted is cumulative and encompasses those listed in Baseline.

## Pre-requesite

- Kyverno CRDs need to be installed (which is done by the chart `kyverno`).

## Check that the component is working

Run `kubectl get clusterpolicies` to retrieve all cluster policies. The following cluster policies should be deployed:

- `disallow-capabilities`
- `disallow-host-namespaces`
- `disallow-host-path`
- `disallow-host-ports`
- `disallow-host-process`
- `disallow-privileged-containers`
- `disallow-proc-mount`
- `disallow-selinux`
- `require-requests-limits`
- `restrict-apparmor-profiles`
- `restrict-seccomp`
- `restrict-sysctls`

## Available values for this Chart

All values are described in the [`kyverno-policies helm chart repository`](https://github.com/kyverno/kyverno/blob/main/charts/kyverno-policies/values.yaml).
Specific values to the Chart provided by Padok are documented in the `values.yaml` file.
