#!/bin/bash

# Script to clean up n8n Kubernetes resources for different environments

# Check if environment is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <environment> [--force]"
  echo "Available environments: dev, test, staging, prod, all"
  exit 1
fi

# Set environment
ENV=$1
FORCE=$2

# Function to delete resources for a specific environment
delete_env() {
  local env=$1
  echo "Cleaning up n8n $env environment..."
  
  if [ "$FORCE" == "--force" ]; then
    kubectl delete -k "$(dirname "$0")/../overlays/$env" --ignore-not-found
  else
    read -p "Are you sure you want to delete all resources in the n8n-$env namespace? (y/N): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
      kubectl delete -k "$(dirname "$0")/../overlays/$env" --ignore-not-found
      echo "Resources in n8n-$env namespace deleted."
    else
      echo "Cleanup cancelled for $env environment."
    fi
  fi
}

# Validate and process environment
if [ "$ENV" == "all" ]; then
  for e in dev test staging prod; do
    delete_env $e
  done
elif [[ "$ENV" =~ ^(dev|test|staging|prod)$ ]]; then
  delete_env $ENV
else
  echo "Invalid environment: $ENV"
  echo "Available environments: dev, test, staging, prod, all"
  exit 1
fi