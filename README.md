# ETIC Notes Terraform on Azure

## Overview

This project provisions the ETIC Notes infrastructure on Azure using Terraform.

The solution follows Infrastructure as Code principles using reusable Terraform modules, remote state, environment-specific configuration files, and CI/CD workflows.

---

## Solution Components

The following Azure resources are deployed:

- Existing Sandbox Resource Group
- Existing Sandbox Virtual Network
- Existing Application Subnet
- Existing Private Endpoint Subnet
- Azure Storage Account
- Azure Storage Private Endpoint
- Azure App Service Plan
- Azure Linux Web App
- User Assigned Managed Identity
- Azure Key Vault
- Azure Log Analytics Workspace
- Azure Diagnostic Settings

---

## Repository Structure

```text
iac/
├── modules/
│   ├── network/
│   ├── storage/
│   └── webapp/
│
├── configuration/
│   ├── dev/
│   │   ├── main.tfvars
│   │   └── backend.tfvars
│   │
│   └── stage/
│       ├── main.tfvars
│       └── backend.tfvars
│
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf

.github/
└── workflows/
```

---

## Remote State

Terraform backend is hosted in Azure Storage.

Storage Account:

```text
ahmednotes680tfstate
```

Container:

```text
tfstate
```

Terraform state locking is provided by the Azure backend.

---

## Environment Separation

The same Terraform code is used for all environments.

Environment-specific values are stored in:

```text
configuration/dev/main.tfvars
configuration/stage/main.tfvars
```

No Terraform resources are duplicated between environments.

---

## Terraform Modules

### Network Module

Responsibilities:

- Access existing sandbox resource group
- Access existing VNet
- Access existing application subnet
- Access existing private endpoint subnet

### Storage Module

Responsibilities:

- Storage Account deployment
- Private Endpoint deployment
- Storage network access restrictions

### WebApp Module

Responsibilities:

- App Service Plan deployment
- Linux Web App deployment

---

## Security Controls

### Storage Account

- Public access disabled
- Private endpoint enabled
- Network ACL restrictions enabled

### Web App

- User Assigned Managed Identity attached

### Key Vault

- RBAC authorization enabled
- Managed identity granted Key Vault Secrets User role

### Monitoring

- Log Analytics Workspace deployed
- Diagnostic settings enabled

---

## Deployment Commands

### Format

```bash
terraform fmt -recursive
```

### Validate

```bash
terraform validate
```

### Plan

```bash
terraform plan -var-file=configuration/dev/main.tfvars
```

### Apply

```bash
terraform apply -var-file=configuration/dev/main.tfvars
```

---

## Outputs

Terraform exposes:

- Web App URL
- Key Vault URI
- Storage Account Name
- Managed Identity ID
- Log Analytics Workspace ID

---

## Idempotency Proof

Terraform was executed after successful deployment without any code changes.

Result:

```text
No changes. Your infrastructure matches the configuration.
```

This confirms the deployment is idempotent.

---

## Destroy Validation

Terraform destroy was executed successfully.

The only remaining operation was Azure Key Vault purge.

The sandbox account does not have permission for:

```text
Microsoft.KeyVault/locations/deletedVaults/purge/action
```

Verification confirmed the Key Vault was deleted successfully.

---

## CI/CD

GitHub Actions workflows were implemented for:

### CI

- terraform fmt -check
- terraform validate
- terraform plan
- tfsec
- Checkov
- Gitleaks

### CD

- Deployment after merge to main

### Limitation

Execution of Terraform plan from GitHub Actions requires Azure authentication.

PwC GitHub authorization and Azure service connection approval were still pending during project completion.

The CI/CD workflows were successfully configured but could not authenticate to Azure until access approval is granted.

---

## Lessons Learned

- Terraform reusable module design
- Azure remote state management
- Azure networking and private endpoints
- Managed identities and RBAC
- Infrastructure security controls
- Terraform idempotency
- CI/CD workflow implementation