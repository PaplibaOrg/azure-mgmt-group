# Repository Structure Instructions (Terraform IaC)

> **Note:** This instruction file is specifically for **Terraform IaC repositories** managing Azure Management Groups.

This document defines the standard folder structure for platform repositories using Terraform IaC for Azure Management Groups.

## Root Structure

```
<repo-root>/
├── .instructions/           # AI instruction files
├── .husky/                  # Git hooks
├── modules/                 # Terraform modules
├── mg/                      # Management group deployment files
├── pipeline/                # Azure DevOps pipelines
├── .gitignore
├── commitlint.config.js
└── package.json
```

## Modules Folder

The `modules/` folder contains all Terraform modules organized by type:

```
modules/
├── resources/          # Resource-level modules (individual resources)
│   └── management-group/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── services/           # Service-level modules (orchestrates resources)
    └── management-groups/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### Module Types

#### Resources (`modules/resources/`)
- Individual Azure resource modules
- Reusable across services
- Standalone modules (minimal dependencies)
- Example: `modules/resources/management-group/` - Creates a single management group

#### Services (`modules/services/`)
- Service-specific modules
- Combines multiple resource modules into a logical service
- References modules in `resources/`
- Example: `modules/services/management-groups/` - Creates entire CAF hierarchy

## Management Group Deployment Structure

### CAF Hierarchy

This repository implements the Azure Cloud Adoption Framework (CAF) management group hierarchy with environment-specific prefixes:

- **Dev**: `dev-plb` (creates `dev-plb-root`, `dev-plb-platform`, etc.)
- **Test**: `test-plb` (creates `test-plb-root`, `test-plb-platform`, etc.)
- **Prod**: `plb` (creates `plb-root`, `plb-platform`, etc.)

### MG Folder Structure

```
mg/
├── main.tf              # Main deployment file, reads JSON configs
├── provider.tf          # Terraform backend and provider configuration
├── dev.tfvr.json        # Development environment configuration
├── test.tfvr.json       # Test environment configuration
└── prod.tfvr.json       # Production environment configuration
```

### JSON Configuration Format

Each `.tfvr.json` file contains environment-specific configuration:

```json
{
  "mg_prefix": "dev-plb",
  "environment": "dev",
  "sequence": "001",
  "location": "eastus",
  "tenant_root_group_id": "<tenant-id>",
  "subscription_ids": [],
  "tags": {
    "environment": "dev",
    "managedBy": "terraform"
  }
}
```

The `main.tf` uses `for_each` with `fileset()` to read all `.tfvr.json` files and deploy management groups for each environment.

## Pipeline Folder

```
pipeline/
├── deploy-management-groups.yaml    # Main pipeline definition
└── templates/
    └── deploy-terraform.yaml        # Reusable Terraform deployment template
```

- All pipeline files go in `pipeline/` folder
- Main pipeline file: `deploy-management-groups.yaml`
- See `PIPELINE_INSTRUCTIONS.md` for pipeline design patterns

## Instructions Folder

```
.instructions/
├── PIPELINE_INSTRUCTIONS.md      # Pipeline design patterns
├── COMMITLINT_INSTRUCTIONS.md    # Commit message standards
└── REPOSITORY_STRUCTURE.md       # This file
```

- Contains AI instruction files
- Prefix with dot (`.`) to keep at top of directory listing
- Use UPPERCASE names for visibility
