# n8n Kubernetes Hosting

This repository contains Kubernetes manifests for deploying n8n workflow automation tool using Kustomize with optimized configurations for different environments.

## Features

- **Multi-environment Support**: Preconfigured environments for dev, test, staging, and production
- **Resource Optimization**: Tiered resource profiles (small, medium, large) for different environments
- **PostgreSQL Database**: Integrated PostgreSQL database configuration
- **Reusable Components**: Common configurations shared across environments
- **Environment-specific Secrets**: Separate secrets for each environment
- **Environment-specific Configs**: Separate configuration for each environment
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
│   │   ├── config-*.env    # Environment-specific configurations
│   │   └── secrets-*.env   # Environment-specific secrets
│   ├── dev/                # Development environment
│   ├── test/               # Test environment
│   ├── staging/            # Staging environment
│   └── prod/               # Production environment
└── scripts/                # Utility scripts
    ├── apply.sh            # Script to apply configurations
    ├── check-status.sh     # Script to check deployment status
    ├── cleanup.sh          # Script to clean up resources
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

# Check deployment status
./scripts/check-status.sh dev

# Clean up resources
./scripts/cleanup.sh test
./scripts/cleanup.sh all --force  # Clean up all environments without confirmation
```

## Resource Profiles

The project includes three resource profiles:

- **Small** (dev, test): 1 replica, 512Mi memory, 200m CPU
- **Medium** (staging): 2 replicas, 1Gi memory, 500m CPU
- **Large** (prod): 3 replicas, 2Gi memory, 1000m CPU

## Environment Configurations

Each environment has specific configurations:

- **Dev**: Development environment with debug logging, development-specific secrets and configs
- **Test**: Testing environment with minimal resources, test-specific secrets and configs
- **Staging**: Pre-production environment with moderate resources, staging-specific secrets and configs
- **Production**: Production environment with high availability, production-specific secrets and configs

## Customization

To customize configurations:

1. Modify resource profiles in `overlays/common/resources-*.yaml`
2. Update environment variables in `overlays/common/env-*.yaml`
3. Update configuration values in `overlays/common/config-*.env`
4. Generate or update secrets in `overlays/common/secrets-*.env`
5. Add environment-specific patches in `overlays/<environment>/kustomization.yaml`