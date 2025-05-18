#!/bin/bash

# Script to show differences between current cluster state and Kubernetes configurations

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

# Show diff using kubectl
echo "Showing differences for n8n $ENV environment configuration..."
kubectl diff -k overlays/$ENV

# Check if diff was successful
if [ $? -eq 0 ]; then
  echo "No differences found for n8n $ENV environment"
elif [ $? -eq 1 ]; then
  echo "Differences found for n8n $ENV environment"
else
  echo "Error running diff for n8n $ENV environment"
  exit 1
fi