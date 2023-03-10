# Kyverno

This manifest deploys [Kyverno](https://github.com/kyverno/kyverno) in GKE.

## Description

Kyverno is a policy engine designed for Kubernetes. It can validate, mutate, and generate configurations using admission controls and background scans.

The full documentation is available on [Kyverno's website](https://kyverno.io/docs/).

## Pre-requesite

No pre-requesite.

## High availability and Single Point of Failure

Since Kyverno provides a validation webhook, no resources can be deployed in case Kyverno's pod are down (hopefully system resources are not impacted). To prevent this issue, it is recommended to deploy Kyverno in high availability mode. You can do this by commenting out the `replicaCount` value in `values.yaml`.

## Check that the component is working

Deploy `kyverno-policies` and run `kubectl get policyreport -A` to retrieve all policy reports.

## Available values for this Chart

All values are described in the [`kyverno helm chart repository`](https://github.com/kyverno/kyverno/tree/main/charts/kyverno/values.yaml).
