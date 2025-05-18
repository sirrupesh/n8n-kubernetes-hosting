# n8n Kubernetes Hosting

This repository contains Kubernetes manifests for deploying n8n workflow automation tool using Kustomize with optimized configurations for different environments.

## Features

- **Multi-environment Support**: Preconfigured environments for dev, test, staging, and production
- **Resource Optimization**: Tiered resource profiles (small, medium, large) for different environments
- **PostgreSQL Database**: Integrated PostgreSQL database configuration
- **Reusable Components**: Common configurations shared across environments
- **Environment-specific Secrets**: Separate secrets for each environment
- **Easy Deployment**: Simple scripts for applying and comparing configurations

## Project Structure

```
.
├── base/                   # Base configurations shared across all environments
│   ├── n8n/                # n8n specific resources
│   ├── postgres/           # PostgreSQL database resources
│   ├── kustomization.yaml  # Base kustomization file
│   └── storageclass.yaml   # Storage class definition
├── overlays/               # Environment-specific overlays
│   ├── common/             # Shared configurations
│   │   ├── resources-*.yaml # Resource profiles (small, medium, large)
│   │   ├── env-*.yaml      # Environment-specific variables
│   │   └── secrets-*.env   # Environment-specific secrets
│   ├── dev/                # Development environment
│   ├── test/               # Test environment
│   ├── staging/            # Staging environment
│   └── prod/               # Production environment
└── scripts/                # Utility scripts
    ├── apply.sh            # Script to apply configurations
    ├── diff.sh             # Script to show differences
    └── generate-secrets.sh # Script to generate secure secrets
```

## Usage

To deploy to a specific environment:

```bash
# Generate secure secrets for an environment
./scripts/generate-secrets.sh dev

# Apply development environment
kubectl apply -k overlays/dev

# Apply test environment
kubectl apply -k overlays/test

# Apply staging environment
kubectl apply -k overlays/staging

# Apply production environment
kubectl apply -k overlays/prod
```

Or use the provided scripts:

```bash
# Apply configuration
./scripts/apply.sh dev

# Show differences
./scripts/diff.sh staging
```

## Resource Profiles

The project includes three resource profiles:

- **Small** (dev, test): 1 replica, 512Mi memory, 200m CPU
- **Medium** (staging): 2 replicas, 1Gi memory, 500m CPU
- **Large** (prod): 3 replicas, 2Gi memory, 1000m CPU

## Environment Configurations

Each environment has specific configurations:

- **Dev**: Development environment with debug logging and development-specific secrets
- **Test**: Testing environment with minimal resources and test-specific secrets
- **Staging**: Pre-production environment with moderate resources and staging-specific secrets
- **Production**: Production environment with high availability and production-specific secrets

## Customization

To customize configurations:

1. Modify resource profiles in `overlays/common/resources-*.yaml`
2. Update environment variables in `overlays/common/env-*.yaml`
3. Generate or update secrets in `overlays/common/secrets-*.env`
4. Add environment-specific patches in `overlays/<environment>/kustomization.yaml`