#!/bin/bash

# Script to generate secure secrets for different environments

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

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SECRETS_DIR="$PROJECT_ROOT/overlays/common"

# Generate random passwords
POSTGRES_ADMIN_PASSWORD=$(openssl rand -base64 20 | tr -dc 'a-zA-Z0-9' | head -c 16)
POSTGRES_N8N_PASSWORD=$(openssl rand -base64 20 | tr -dc 'a-zA-Z0-9' | head -c 16)
N8N_ENCRYPTION_KEY=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32)
N8N_BASIC_AUTH_PASSWORD=$(openssl rand -base64 20 | tr -dc 'a-zA-Z0-9' | head -c 16)

# Create secrets file
cat > "$SECRETS_DIR/secrets-${ENV}.env" << EOF
POSTGRES_ADMIN_PASSWORD=${POSTGRES_ADMIN_PASSWORD}
POSTGRES_N8N_PASSWORD=${POSTGRES_N8N_PASSWORD}
N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD}
EOF

echo "Generated secure secrets for ${ENV} environment"
echo "Secrets file: $SECRETS_DIR/secrets-${ENV}.env"