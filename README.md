
# Azure Application Gateway — Modular Bicep Project

This repository provides a modular refactor of the exported Application Gateway ARM/Bicep template you supplied.
It keeps original **resource names**, **tags**, and internal identifiers unchanged while making the template modular and pipeline-ready.

## Layout
```
/ (repo root)
├─ main.bicep                # Orchestrator (calls modules)
├─ parameters-prod.json      # Pre-filled params for LAB (edit as needed)
├─ azure-pipelines.yml       # Azure DevOps pipeline (AzureCLI task)
├─ README.md
└─ modules/
   ├─ appgw.bicep            # Application Gateway resource (full body preserved)
   ├─ vnet.bicep             # lightweight module referencing existing VNet id
   ├─ publicIP.bicep         # lightweight module referencing existing Public IP id
   └─ diagnostics.bicep      # diagnostic settings to Log Analytics example
```

## Quick steps to deploy to LAB subscription via Azure DevOps
1. Create a new Azure DevOps project and repo (or use existing). Push these files to the repo.
2. Create an Azure Resource Manager service connection in Azure DevOps that has contributor rights on the target subscription.
3. Update `azure-pipelines.yml` variable `azureSubscription` with the service connection name and `resourceGroupName` with the target RG.
4. Edit `parameters-prod.json` if you need to change any resource ids (e.g., Log Analytics workspace id).
5. Run the pipeline (it triggers on `main` branch). The pipeline runs `az deployment group create` to deploy the modular bicep template.

## Key notes
- **Do not change resource names/tags** — this project preserves the names from the exported template.
- SSL certificate content is left as-is in the export; for production you should replace the certificate objects with Key Vault references (example below).
- Diagnostics module is optional: provide a Log Analytics workspace resource id in `parameters-prod.json` to enable diagnostics deployment.

## KeyVault certificate example (snippet)
Instead of inline `sslCertificates` you can use Key Vault reference like this in `appgw.bicep` (example):
```bicep
resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  id: '/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.KeyVault/vaults/<vaultName>'
}

sslCertificates: [
  {
    name: 'tls-from-kv'
    properties: {
      keyVaultSecretId: 'https://${kv.name}.vault.azure.net/secrets/<secret-name>/<secret-version>'
    }
  }
]
```

## Next steps I can do for you (pick one)
- Replace inline `sslCertificates` with Key Vault references for each certificate (requires KV secret ids).
- Fully expand the omitted `...` sections so the `appgw.bicep` file exactly matches the exported template (I can finish this if you want).
- Create the repo in your GitHub and push the code (requires a PAT) or generate a ZIP (I will provide download).

