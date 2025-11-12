# Azure Kubernetes Service (AKS) Infrastructure Automation

## Project Summary

This project automates the deployment of Azure Kubernetes Service (AKS) clusters across multiple environments (dev, staging, prod) using Terraform and Azure DevOps Pipelines. It implements infrastructure as code (IaC) best practices with remote state management, modular architecture, and automated CI/CD workflows.

### Key Features
- Multi-environment AKS cluster provisioning (dev/staging/prod)
- Automated Azure Service Principal creation and management
- Secure Key Vault integration for secrets management
- Remote state management using Azure Storage
- CI/CD pipelines for infrastructure deployment and destruction
- Modular Terraform architecture for reusability

---

## Architecture Overview

![alt text](Assets/Architecture.png)

### Architecture Description

This project implements a complete end-to-end Azure DevOps and Terraform infrastructure automation solution:

#### 1. Source Control & CI/CD Layer
- **GitHub Repository**: Stores Terraform code and pipeline definitions
- **Azure DevOps Pipelines**: Orchestrates infrastructure deployment
  - Create Pipeline: Validates, plans, and applies infrastructure
  - Destroy Pipeline: Safely tears down resources with approval gates
- **Branch Strategy**: Feature branches → Pull Requests → Main branch deployment

#### 2. Terraform State Management
- **Azure Storage Account**: Remote backend for Terraform state
  - `tfdevbackend2024piyush`: Dev environment state
  - `tfstagebackend2024piyush`: Staging environment state
- **Blob Container**: `tfstate` stores state files with locking
- **Resource Group**: `terraform-state-rg` in Canada Central

#### 3. Azure Infrastructure Components

```
┌─────────────────────────────────────────────────────────────┐
│                    Azure Subscription                       │
│                                                             │
│  ┌────────────────────────────────────────────────────┐     │
│  │  Resource Group (per environment)                  │     │
│  │                                                    │     │
│  │  ┌──────────────────┐      ┌──────────────────┐    │     │
│  │  │ Service Principal│──────│   Key Vault      │    │     │
│  │  │  - Client ID     │      │  - Secrets       │    │     │
│  │  │  - Client Secret │      │  - RBAC enabled  │    │     │
│  │  └──────────────────┘      └──────────────────┘    │     │
│  │           │                                        │     │
│  │           │ Authenticates                          │     │
│  │           ▼                                        │     │
│  │  ┌──────────────────────────────────────────┐      │     │
│  │  │   AKS Cluster                            │      │     │
│  │  │   - Latest Kubernetes version            │      │     │
│  │  │   - Auto-scaling (1-3 nodes)             │      │     │
│  │  │   - Standard_DS2_v2 VMs                  │      │     │
│  │  │   - 3 Availability Zones                 │      │     │
│  │  │   - Azure CNI networking                 │      │     │
│  │  │   - Standard Load Balancer               │      │     │
│  │  └──────────────────────────────────────────┘      │     │
│  └────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

#### 4. Multi-Environment Setup
- **Dev Environment**: Development and testing
- **Staging Environment**: Pre-production validation
- **Prod Environment**: Production workloads (pipeline ready)

Each environment is completely isolated with:
- Dedicated resource groups
- Separate AKS clusters
- Independent Key Vaults
- Isolated Service Principals
- Environment-specific Terraform state files

#### 5. Deployment Flow

```
Developer → Feature Branch → Pull Request → Code Review
                                    ↓
                            Merge to Main Branch
                                    ↓
                          Azure DevOps Pipeline
                                    ↓
                    ┌───────────────┴───────────────┐
                    ↓                               ↓
            Terraform Validate              Terraform Plan
                    ↓                               ↓
            Manual Approval                 Terraform Apply
                    ↓                               ↓
            ┌───────┴────────┬──────────────┬──────┴─────┐
            ↓                ↓              ↓            ↓
        Dev Cluster    Staging Cluster  Prod Cluster  Outputs
            ↓                ↓              ↓            ↓
        Testing         UAT Testing    Production   Kubeconfig
```

#### 6. Security & Access Control
- **Service Principal**: Contributor role at subscription level
- **Key Vault**: RBAC-based access control
- **Secrets Management**: All credentials stored in Key Vault
- **SSH Keys**: Secure Linux node access
- **State Locking**: Prevents concurrent modifications
- **Sensitive Outputs**: Marked and protected in Terraform

## AGENDA

### 1. Login / Set Variable
- **Prep**
  - Backend dev
  - Backend stage

### 2. Understand Terraform Code
- Execute Terraform manually
  - dev cluster
  - stage cluster

### 3. Destroy these

### 4. Import the Code in Terraform → BRANCHING STRATEGY
- **Azure Pipelines**
  - create
  - destroy

### 5. Execute Pipeline
- Code change + Permissions (KV + Admin + Extra)

### 6. Destroy

## BRANCHING STRATEGIES

### Trunk-Based Approach
- git flow
- GitHub flow
- feature branch

### Workflow Diagram
```
MAIN branch (white) ──────────────────────────────────────
                                      │
Feature branch (blue)   ┬──────────────────────────┬
                        │                          │
                    feature-101                  feature-102
                        │                          │
                     Merge                        Merge
                        │                          │
                        └──────────────────────────┘
                                      │
                                  Pull Request
```

### CI/CD Pipeline Flow
- **MAIN** → Testing → Dev → Stage → Prod
- **Feature branches** → Unit Tests, Static Code Analysis, Integration, Code Quality
- **Observability** monitoring across all stages

---

## AZURE RESOURCES

### Remote Backend
- **dev** → Pre-req.sn
- **staging** → Pre-req.sn

### AKS CLUSTER
- Build Agent
  - Self-hosted
  - MS hosted

### Key Vault + Secret
### Service Principal
### Resource Group

### Pipelines
- **CREATE RESOURCES**
- **DESTROY RESOURCES**

---

## How It Works

### 1. Project Structure

```
├── modules/                    # Reusable Terraform modules
│   ├── aks/                   # AKS cluster configuration
│   ├── keyvault/              # Azure Key Vault setup
│   └── ServicePrincipal/      # Service Principal creation
├── dev/                       # Development environment config
├── staging/                   # Staging environment config
├── pipeline/                  # Azure DevOps pipeline definitions
│   ├── create.yaml           # Infrastructure creation pipeline
│   └── destroy.yaml          # Infrastructure destruction pipeline
├── scripts/                   # Setup scripts
│   └── dev.sh                # Backend storage account creation
└── provider.tf               # Azure provider configuration
```

### 2. Infrastructure Components

#### Service Principal Module
- Creates Azure AD application and service principal
- Generates client credentials (ID and secret)
- Assigns Contributor role at subscription level
- Stores credentials securely in Key Vault

#### Key Vault Module
- Provisions Azure Key Vault with premium SKU
- Enables disk encryption and RBAC authorization
- Configures soft delete with 7-day retention
- Stores service principal secrets

#### AKS Module
- Deploys Kubernetes cluster with latest stable version
- Configures auto-scaling node pool (1-3 nodes)
- Uses Standard_DS2_v2 VMs across 3 availability zones
- Integrates with service principal for authentication
- Generates kubeconfig file for cluster access
- Implements Azure CNI networking

### 3. Environment Configuration

Each environment (dev/staging) has:
- **Separate remote state**: Stored in dedicated Azure Storage accounts
- **Independent resources**: Isolated resource groups and clusters
- **Environment-specific variables**: Configured via terraform.tfvars
- **Backend configuration**: Points to environment-specific state files

### 4. Deployment Workflow

#### Prerequisites Setup (scripts/dev.sh)
1. Creates resource group for Terraform state
2. Provisions storage accounts for dev and staging
3. Creates blob containers for state files

#### Manual Deployment
```bash
cd dev  # or staging
terraform init
terraform plan
terraform apply
```

#### Automated CI/CD Pipeline (create.yaml)
1. **Validate Stage**: Runs terraform validate on feature branches
2. **Dev Deploy**: Auto-deploys to dev on main branch merge
3. **Test Deploy**: Promotes to test environment after dev success
4. Triggers on main branch or feature/* branches
5. Uses Azure Service Connection for authentication

#### Destruction Pipeline (destroy.yaml)
1. **Plan Destroy**: Shows resources to be destroyed
2. **Destroy Stage**: Requires manual approval per environment
3. Parameterized for dev/staging/prod selection

### 5. State Management

- **Remote Backend**: Azure Storage with blob containers
- **State Locking**: Prevents concurrent modifications
- **Environment Isolation**: Separate state files per environment
  - dev: `tfdevbackend2024piyush/tfstate/dev.tfstate`
  - staging: `tfstagebackend2024piyush/tfstate/stage.tfstate`

### 6. Security Features

- Service principal credentials stored in Key Vault
- RBAC-enabled Key Vault access
- Sensitive outputs marked as sensitive in Terraform
- Purge protection disabled for development flexibility
- SSH key-based Linux admin access for AKS nodes

### 7. Outputs

After deployment, the following are available:
- Resource group name
- Service principal client ID
- Service principal client secret (sensitive)
- Kubeconfig file for kubectl access
