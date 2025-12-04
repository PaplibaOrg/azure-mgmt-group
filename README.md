# Azure Management Group Management

Terraform infrastructure-as-code for managing Azure Management Group hierarchies following Azure Cloud Adoption Framework (CAF) best practices.

## Overview

This repository provides Terraform modules to deploy and manage Azure Management Group hierarchies according to CAF recommendations. It follows the same structure and patterns as the `azure-iam` repository for consistency.

## Repository Structure

```
azure-mgmt-group/
├── .husky/                          # Git hooks for commit linting
├── .instructions/                   # Platform standards and guidelines
├── modules/
│   ├── resources/
│   │   └── management-group/        # Single management group resource module
│   └── services/
│       └── management-groups/       # CAF hierarchy orchestration module
├── mg/                              # Management group deployment files
│   ├── main.tf                      # Main deployment file
│   ├── provider.tf                  # Terraform backend and provider config
│   ├── dev.tfvr.json                # Development environment configuration
│   ├── test.tfvr.json               # Test environment configuration
│   └── prod.tfvr.json               # Production environment configuration
├── pipeline/
│   ├── deploy-management-groups.yaml
│   └── templates/
│       └── deploy-terraform.yaml
├── .gitignore
├── commitlint.config.js
├── package.json
└── README.md
```

## CAF Management Group Hierarchy

This repository implements the standard Azure Cloud Adoption Framework management group hierarchy with environment-specific prefixes:

### Development Environment (`dev.tfvr.json`)
```
Tenant Root
└── dev-plb-root
    ├── dev-plb-platform
    │   ├── dev-plb-management
    │   ├── dev-plb-connectivity
    │   ├── dev-plb-identity
    │   └── dev-plb-security
    ├── dev-plb-landingzones
    │   ├── dev-plb-corp
    │   └── dev-plb-online
    ├── dev-plb-sandbox
    └── dev-plb-decommissioned
```

### Test Environment (`test.tfvr.json`)
```
Tenant Root
└── test-plb-root
    ├── test-plb-platform
    │   ├── test-plb-management
    │   ├── test-plb-connectivity
    │   ├── test-plb-identity
    │   └── test-plb-security
    ├── test-plb-landingzones
    │   ├── test-plb-corp
    │   └── test-plb-online
    ├── test-plb-sandbox
    └── test-plb-decommissioned
```

### Production Environment (`prod.tfvr.json`)
```
Tenant Root
└── plb-root
    ├── plb-platform
    │   ├── plb-management
    │   ├── plb-connectivity
    │   ├── plb-identity
    │   └── plb-security
    ├── plb-landingzones
    │   ├── plb-corp
    │   └── plb-online
    ├── plb-sandbox
    └── plb-decommissioned
```

## Prerequisites

- Azure subscription with Management Group Contributor role at tenant root
- Terraform >= 1.0
- Azure CLI installed and configured
- Azure DevOps with self-hosted agent pool (`default`)
- User-assigned managed identity: `id-mg-vending-eus-dev-001` (for dev environment)
- Node.js and npm (for commit linting)

## Getting Started

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/PaplibaOrg/azure-mgmt-group.git
cd azure-mgmt-group

# Install git hooks for commit message validation
npm install
```

### Configuration

1. **Update JSON Configuration Files**

   Edit the JSON files in `mg/` directory to set your tenant root group ID:

   ```json
   {
     "mg_prefix": "dev-plb",
     "environment": "dev",
     "location": "eastus",
     "tenant_root_group_id": "<your-tenant-id>"
   }
   ```

2. **Update Terraform Backend**

   Edit `mg/provider.tf` to configure your Terraform state backend:

   ```hcl
   terraform {
     backend "azurerm" {
       resource_group_name  = "rg-tf-state-eus-dev-001"
       storage_account_name = "sttfstateeusdev001"
       container_name       = "tfstate"
       key                  = "management-groups.tfstate"
     }
   }
   ```

## Deployment

### Azure DevOps Pipeline (Recommended)

The repository uses a template-based pipeline with Terraform Plan → Apply pattern:

**Pipeline Flow:**
```
Dev:  Plan_MG_Dev → Apply_MG_Dev
Test: Plan_MG_Test → Approval_Test → Apply_MG_Test (when configured)
Prod: Plan_MG_Prod → Approval_Prod → Apply_MG_Prod (when configured)
```

**Setup Steps:**

1. **Configure Service Connection** in Azure DevOps:
   - Name: `id-mg-vending-eus-dev-001` (for dev)
   - Type: Azure Resource Manager (Workload Identity Federation)
   - Managed Identity: User-assigned managed identity

2. **Assign Permissions** to the managed identity:
   ```bash
   # Management Group Contributor at tenant root
   az role assignment create \
     --assignee <managed-identity-principal-id> \
     --role "Management Group Contributor" \
     --scope /providers/Microsoft.Management/managementGroups/<tenant-root-id>
   ```

3. **Create Azure DevOps Environments**:
   - Pipelines → Environments → Create:
     - `Dev` (no approval)
     - `Test` (optional approval)
     - `Prod` (add approval checks)

4. **Create Pipeline** in Azure DevOps:
   - Pipelines → New Pipeline → Azure Repos Git
   - Select repository → Existing Azure Pipelines YAML file
   - Path: `/pipeline/deploy-management-groups.yaml`

5. **Run Pipeline**: Push to `main` branch or manually trigger

### Manual Deployment (Local)

```bash
cd mg

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

## Module Structure

### Resource Module (`modules/resources/management-group/`)

Creates a single Azure Management Group resource.

**Variables:**
- `name` - Management group name
- `display_name` - Display name
- `parent_management_group_id` - Parent MG ID

### Service Module (`modules/services/management-groups/`)

Orchestrates the creation of the entire CAF hierarchy.

**Variables:**
- `mg_prefix` - Prefix for MG names. Should be shorthand, less than 4 characters, and in uppercase (e.g., "DEV-PLB", "TEST-PLB", "PLB")
- `tenant_root_group_id` - Tenant root management group ID
- `environment` - Environment name (dev, test, prod)

**Outputs:**
- All management group IDs (root, platform, landingzones, sandbox, decommissioned, and all children)

## Configuration Files

### JSON Configuration Format

The `mg.tfvars.json` file contains the base configuration:

```json
{
  "tenant_root_group_id": "<tenant-id>",
  "company_prefix": "PLB",
  "root_display_name": "Root",
  "first_level_hierarchy": { ... }
}
```

**Configuration Requirements:**
- `company_prefix` - Should be shorthand, less than 4 characters, and in uppercase (e.g., "PLB")
- The `mg_prefix` is automatically constructed from `company_prefix` and `environment` (e.g., "dev-PLB", "test-PLB", "PLB" for prod)

The `main.tf` reads the configuration and creates management groups based on the environment variable passed from the pipeline.

## Development Workflow

### Commit Messages

All commits must follow [Conventional Commits](https://www.conventionalcommits.org/) format:

```bash
# Good examples
git commit -m "feat: add new management group"
git commit -m "fix: update subscription assignment"
git commit -m "docs: update README"

# Bad examples (rejected by git hooks)
git commit -m "updated stuff"
git commit -m "fix"
```

**Commit Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

### Making Changes

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature
   ```

2. Make changes to Terraform modules or configuration files

3. Test locally:
   ```bash
   cd mg
   terraform init
   terraform plan
   ```

4. Commit with conventional commit message (validated automatically)

5. Push and create pull request

## Security Considerations

- ✅ Management groups require tenant-scope permissions
- ✅ Use managed identities for service connections (no secrets in code)
- ✅ Service connections secured in Azure DevOps
- ✅ Least privilege role assignments
- ✅ State files stored in secure Azure Storage backend

## Troubleshooting

**Issue:** "Management group already exists"
- **Solution:** Delete existing management groups or use different prefix in JSON files

**Issue:** "Insufficient permissions"
- **Solution:** Verify managed identity has "Management Group Contributor" role at tenant root

**Issue:** "State locked" error
- **Solution:** Check for stuck locks, use `terraform force-unlock` if needed

**Issue:** Pipeline fails with "Authentication failed"
- **Solution:** Verify service connection and ARM environment variables

## Learn More

- [Azure Management Groups](https://docs.microsoft.com/azure/governance/management-groups/)
- [Cloud Adoption Framework](https://docs.microsoft.com/azure/cloud-adoption-framework/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Conventional Commits](https://www.conventionalcommits.org/)

## License

ISC



