#!/bin/bash

# Apply base resources
kubectl apply -k .

# Check deployment status
echo "Checking deployment status..."
kubectl -n n8n get pods

# Wait for deployments to be ready
echo "Waiting for deployments to be ready..."
kubectl -n n8n wait --for=condition=available deployment/postgres --timeout=120s
kubectl -n n8n wait --for=condition=available deployment/n8n --timeout=120s

echo "Deployment complete! Access n8n through the configured ingress."

# Uncomment to clean up
# kubectl delete -k .