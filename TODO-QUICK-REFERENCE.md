# TODO Quick Reference Guide

## 🔍 Find All TODOs

**PowerShell Command:**
```powershell
Select-String -Path .\dev\*,.\staging\*,.\scripts\*,.\pipeline\*,.\modules\* -Pattern "TODO" -Recurse
```

**Git Bash / Linux:**
```bash
grep -r "TODO" dev/ staging/ scripts/ pipeline/ modules/
```

---

## ✅ TODO Checklist by File

### 1️⃣ scripts/dev.sh (Lines 3-6)
```bash
STAGE_SA_ACCOUNT=tfstagebackend2024piyush    # Change "piyush" to your name
DEV_SA_ACCOUNT=tfdevbackend2024piyush        # Change "piyush" to your name
```
**Rules:** 3-24 chars, lowercase, globally unique

---

### 2️⃣ dev/terraform.tfvars (Lines 2-6)
```hcl
rgname                 = "dev-piyush-rg"           # Change "piyush"
service_principal_name = "dev-piyush-spn"          # Change "piyush"
keyvault_name          = "dev-piyush-kv-101"       # Change "piyush" (globally unique!)
SUB_ID = ""                                        # ⚠️ REQUIRED: Add your subscription ID
cluster_name = "dev-piyush-cluster"                # Change "piyush"
```

**Get Subscription ID:**
```bash
az account show --query id -o tsv
```

---

### 3️⃣ staging/terraform.tfvars (Lines 2-7)
```hcl
rgname                 = "stage-piyush-rg"         # Change "piyush"
service_principal_name = "stage-piyush-spn"        # Change "piyush"
keyvault_name          = "stage-piyush-kv-101"     # Change "piyush" (globally unique!)
SUB_ID = ""                                        # ⚠️ REQUIRED: Add your subscription ID
cluster_name = "stage-piyush-cluster"              # Change "piyush"
```

---

### 4️⃣ dev/backend.tf (Line 4)
```hcl
storage_account_name = "tfdevbackend2024piyush"    # Must match scripts/dev.sh
```

---

### 5️⃣ staging/backend.tf (Line 4)
```hcl
storage_account_name = "tfstagebackend2024piyush"  # Must match scripts/dev.sh
```

---

### 6️⃣ modules/aks/variables.tf (Line 11)
```hcl
default = ".ssh/id_rsa.pub"                        # Verify SSH key exists
```

**Generate SSH key if needed:**
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

---

### 7️⃣ pipeline/create.yaml (Lines 12, 30, 33, 63)
```yaml
- group: terraform-secrets                         # Create in Azure DevOps
backendServiceArm: 'Azure-Service-Connection'      # Create in Azure DevOps
backendAzureRmStorageAccountName: 'tfstatedev2024' # Change to match your name
workingDirectory: '$(System.DefaultWorkingDirectory)/terraform/dev'  # Verify path
```

---

### 8️⃣ pipeline/destroy.yaml (Lines 12, 28)
```yaml
- group: terraform-secrets                         # Create in Azure DevOps
environmentServiceNameAzureRM: 'Azure-Service-Connection'  # Create in Azure DevOps
```

---

## 🎯 Priority Order

### CRITICAL (Must do before anything):
1. ✅ Add Azure Subscription ID in both terraform.tfvars files
2. ✅ Change all storage account names (must be globally unique)
3. ✅ Change all key vault names (must be globally unique)
4. ✅ Verify SSH key exists at ~/.ssh/id_rsa.pub

### IMPORTANT (Before running):
5. ✅ Update all "piyush" references to your identifier
6. ✅ Match backend.tf storage names with scripts/dev.sh

### FOR PIPELINES (If using Azure DevOps):
7. ✅ Create Azure Service Connection in Azure DevOps
8. ✅ Create terraform-secrets variable group
9. ✅ Update storage account name in create.yaml

---

## 🔧 Quick Commands

### Check if storage account name is available:
```bash
az storage account check-name --name tfdevbackend2024yourname
```

### Check if key vault name is available:
```bash
az keyvault list --query "[?name=='dev-yourname-kv-101']"
```

### Get your subscription ID:
```bash
az account show --query id -o tsv
```

### List all subscriptions:
```bash
az account list --output table
```

### Set active subscription:
```bash
az account set --subscription <SUBSCRIPTION_ID>
```

---

## 📝 Example Replacements

If your name is "john":

| Original | Replace With |
|----------|-------------|
| `tfdevbackend2024piyush` | `tfdevbackend2024john` |
| `tfstagebackend2024piyush` | `tfstagebackend2024john` |
| `dev-piyush-rg` | `dev-john-rg` |
| `dev-piyush-spn` | `dev-john-spn` |
| `dev-piyush-kv-101` | `dev-john-kv-101` |
| `dev-piyush-cluster` | `dev-john-cluster` |
| `stage-piyush-rg` | `stage-john-rg` |
| `stage-piyush-spn` | `stage-john-spn` |
| `stage-piyush-kv-101` | `stage-john-kv-101` |
| `stage-piyush-cluster` | `stage-john-cluster` |

---

## ⚠️ Common Mistakes to Avoid

❌ Forgetting to add Subscription ID (will fail immediately)
❌ Using uppercase in storage account names (not allowed)
❌ Using same names as "piyush" (might conflict if already taken)
❌ Mismatching storage names between backend.tf and scripts/dev.sh
❌ Not creating SSH keys before deployment

---

## ✅ Verification Before Starting

Run these checks:

```bash
# 1. Check Azure login
az account show

# 2. Verify SSH key exists
ls -la ~/.ssh/id_rsa.pub

# 3. Check storage name availability
az storage account check-name --name tfdevbackend2024yourname

# 4. Verify all TODOs are addressed
grep -r "TODO" dev/ staging/ scripts/ pipeline/ modules/
```

If all checks pass, you're ready to run:
```bash
bash scripts/dev.sh
```

---

**Last Updated:** After adding all TODO comments
**Status:** ✅ Ready for manual configuration
