#!/bin/bash
set -e

# Apply resources
kubectl apply -k .

# Wait for deployments
kubectl -n n8n wait --for=condition=available deployment/postgres deployment/n8n --timeout=120s

# Show access info
echo "Deployment complete. Access n8n through the ingress."
kubectl -n n8n get ingress

# Uncomment to clean up
# kubectl delete -k .