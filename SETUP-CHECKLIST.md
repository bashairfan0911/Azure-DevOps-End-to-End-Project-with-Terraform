# Setup Checklist - Before Starting the Project

## ⚠️ CRITICAL: Complete ALL items before running Terraform or Pipelines

### 1. Azure Prerequisites
- [ ] Have an active Azure subscription
- [ ] Get your Azure Subscription ID: `az account show --query id -o tsv`
- [ ] Install Azure CLI: `az --version`
- [ ] Login to Azure: `az login`

### 2. SSH Key Setup (Required for AKS)
- [ ] Generate SSH key if not exists: `ssh-keygen -t rsa -b 4096`
- [ ] Verify SSH key exists at: `~/.ssh/id_rsa.pub`
- [ ] Or update path in `modules/aks/variables.tf` (line with TODO comment)

### 3. Update Configuration Files

#### 📁 scripts/dev.sh
- [ ] Line 3-5: Change storage account names (replace "piyush" with your identifier)
  - Must be globally unique
  - 3-24 characters, lowercase letters and numbers only
  - Example: `tfdevbackend2024yourname`

#### 📁 dev/terraform.tfvars
- [ ] Line 2: Change `rgname` (resource group name)
- [ ] Line 3: Change `service_principal_name`
- [ ] Line 4: Change `keyvault_name` (must be globally unique)
- [ ] Line 5: **REQUIRED** - Add your Azure Subscription ID
- [ ] Line 6: Change `cluster_name`

#### 📁 staging/terraform.tfvars
- [ ] Line 2: Change `rgname` (resource group name)
- [ ] Line 3: Change `service_principal_name`
- [ ] Line 4: Change `keyvault_name` (must be globally unique)
- [ ] Line 5: **REQUIRED** - Add your Azure Subscription ID
- [ ] Line 7: Change `cluster_name`

#### 📁 dev/backend.tf
- [ ] Line 4: Change `storage_account_name` (must match scripts/dev.sh)

#### 📁 staging/backend.tf
- [ ] Line 4: Change `storage_account_name` (must match scripts/dev.sh)

### 4. Azure DevOps Setup (For Pipeline Deployment)

#### Create Service Connection
- [ ] Go to Azure DevOps → Project Settings → Service Connections
- [ ] Create new Azure Resource Manager connection
- [ ] Name it: `Azure-Service-Connection` (or update pipeline files)
- [ ] Grant access to all pipelines

#### Create Variable Group
- [ ] Go to Pipelines → Library → Variable Groups
- [ ] Create group named: `terraform-secrets`
- [ ] Add any required secrets (if needed)

#### Update Pipeline Files
- [ ] `pipeline/create.yaml` - Line 12: Verify variable group name
- [ ] `pipeline/create.yaml` - Line 24: Verify service connection name
- [ ] `pipeline/create.yaml` - Line 26: Update storage account name
- [ ] `pipeline/destroy.yaml` - Line 12: Verify variable group name
- [ ] `pipeline/destroy.yaml` - Line 28: Verify service connection name

### 5. Naming Conventions to Follow

#### Storage Account Names
- ✅ Globally unique across all Azure
- ✅ 3-24 characters
- ✅ Lowercase letters and numbers only
- ❌ No hyphens, underscores, or special characters

#### Key Vault Names
- ✅ Globally unique across all Azure
- ✅ 3-24 characters
- ✅ Alphanumeric and hyphens
- ✅ Must start with a letter

#### Resource Group Names
- ✅ Can contain alphanumeric, underscores, hyphens, periods
- ✅ Up to 90 characters
- ✅ Unique within subscription

### 6. Deployment Order

1. **First Time Setup**
   ```bash
   # Run the setup script to create backend storage
   bash scripts/dev.sh
   ```

2. **Deploy Dev Environment**
   ```bash
   cd dev
   terraform init
   terraform plan
   terraform apply
   ```

3. **Deploy Staging Environment**
   ```bash
   cd ../staging
   terraform init
   terraform plan
   terraform apply
   ```

4. **Setup Azure DevOps Pipelines** (Optional)
   - Import `pipeline/create.yaml`
   - Import `pipeline/destroy.yaml`
   - Configure triggers and approvals

### 7. Quick Find TODO Comments

Search for "TODO" in these files:
```bash
grep -r "TODO" dev/
grep -r "TODO" staging/
grep -r "TODO" scripts/
grep -r "TODO" pipeline/
grep -r "TODO" modules/
```

Or in PowerShell:
```powershell
Select-String -Path dev\*,staging\*,scripts\*,pipeline\*,modules\* -Pattern "TODO" -Recurse
```

### 8. Verification Steps

Before running Terraform:
- [ ] All TODO comments addressed
- [ ] Azure CLI logged in: `az account show`
- [ ] Correct subscription selected: `az account set --subscription <SUB_ID>`
- [ ] SSH key exists and accessible
- [ ] Storage account names are unique (test with `az storage account check-name --name <name>`)
- [ ] Key vault names are unique

### 9. Common Issues to Avoid

❌ **Don't forget to:**
- Add Subscription ID in terraform.tfvars files
- Make storage account names globally unique
- Make key vault names globally unique
- Create SSH keys before deployment
- Run scripts/dev.sh before terraform init

✅ **Remember to:**
- Use lowercase for storage account names
- Keep names under character limits
- Match backend.tf storage names with scripts/dev.sh
- Create Azure DevOps service connection before running pipelines

---

## Need Help?

- Azure Subscription ID: `az account show --query id -o tsv`
- Check storage name availability: `az storage account check-name --name <yourname>`
- Generate SSH key: `ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa`
- List Azure locations: `az account list-locations -o table`

---

**Status**: ⏳ Ready to start after completing checklist
