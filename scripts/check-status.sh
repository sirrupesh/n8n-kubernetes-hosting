#!/bin/bash

# Script to check the status of n8n Kubernetes resources for different environments

# Check if environment is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <environment>"
  echo "Available environments: dev, test, staging, prod"
  exit 1
fi

# Set environment
ENV=$1

# Validate environment
if [[ ! "$ENV" =~ ^(dev|test|staging|prod)$ ]]; then
  echo "Invalid environment: $ENV"
  echo "Available environments: dev, test, staging, prod"
  exit 1
fi

# Set namespace
NAMESPACE="n8n-$ENV"

# Print header
echo "===== Checking n8n $ENV environment status ====="
echo "Namespace: $NAMESPACE"
echo

# Check namespace exists
echo "Checking namespace..."
if kubectl get namespace "$NAMESPACE" &>/dev/null; then
  echo "✅ Namespace $NAMESPACE exists"
else
  echo "❌ Namespace $NAMESPACE does not exist"
  exit 1
fi
echo

# Check deployments
echo "Checking deployments..."
kubectl get deployments -n "$NAMESPACE" -o custom-columns=NAME:.metadata.name,READY:.status.readyReplicas,DESIRED:.spec.replicas,STATUS:.status.conditions[?\(@.type==\"Available\"\)].status
echo

# Check pods
echo "Checking pods..."
kubectl get pods -n "$NAMESPACE" -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,READY:.status.containerStatuses[0].ready,RESTARTS:.status.containerStatuses[0].restartCount
echo

# Check services
echo "Checking services..."
kubectl get services -n "$NAMESPACE" -o custom-columns=NAME:.metadata.name,TYPE:.spec.type,CLUSTER-IP:.spec.clusterIP,EXTERNAL-IP:.status.loadBalancer.ingress[0].hostname
echo

# Check ingresses
echo "Checking ingresses..."
kubectl get ingress -n "$NAMESPACE" -o custom-columns=NAME:.metadata.name,HOSTS:.spec.rules[*].host,ADDRESS:.status.loadBalancer.ingress[0].hostname
echo

# Check persistent volume claims
echo "Checking persistent volume claims..."
kubectl get pvc -n "$NAMESPACE" -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,VOLUME:.spec.volumeName,CAPACITY:.status.capacity.storage
echo

# Check configmaps
echo "Checking configmaps..."
kubectl get configmaps -n "$NAMESPACE" -o custom-columns=NAME:.metadata.name
echo

# Check secrets
echo "Checking secrets..."
kubectl get secrets -n "$NAMESPACE" -o custom-columns=NAME:.metadata.name,TYPE:.type
echo

# Check logs for n8n deployment (last 10 lines)
echo "Recent n8n logs (last 10 lines):"
kubectl logs -n "$NAMESPACE" -l app=n8n --tail=10 2>/dev/null || echo "No logs available"
echo

echo "===== Status check complete ====="