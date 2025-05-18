#!/bin/bash

# Script to apply n8n Kubernetes configurations for different environments

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

# Apply Kustomize configuration
echo "Applying n8n $ENV environment configuration..."
kubectl apply -k overlays/$ENV

# Check if apply was successful
if [ $? -eq 0 ]; then
  echo "Successfully applied n8n $ENV environment configuration"
else
  echo "Failed to apply n8n $ENV environment configuration"
  exit 1
fi