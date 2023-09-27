<#
  .SYNOPSIS
    Migrate secrets between two Azure Key Vaults in different subscriptions.

  .DESCRIPTION
    This script is used to migrate secrets from an old Azure Key Vault in one subscription to a new Azure Key Vault in another subscription.
    The script lists all secrets in the old Key Vault and migrates them to the new Key Vault.
    If any secret cannot be downloaded from the old Key Vault, a warning is displayed.
    The script requires the Azure CLI to be installed and available.

  .EXAMPLE
    $MY_OLD_SUBSCRIPTION="<MY_OLD_SUBSCRIPTION>";
    $MY_OLD_KEYVAULT="<MY_OLD_KEYVAULT>";
    $MY_NEW_SUBSCRIPTION="<MY_NEW_SUBSCRIPTION>";
    $MY_NEW_KEYVAULT="<MY_NEW_KEYVAULT>";
    Run the script with the above variables properly set.

  .NOTES
    Make sure to authenticate with Azure CLI before running the script, and that you have the necessary permissions on both Key Vaults.
#>

# **Azure info**
$MY_OLD_SUBSCRIPTION="<MY_OLD_SUBSCRIPTION>";
$MY_OLD_KEYVAULT="<MY_OLD_KEYVAULT>";

$MY_NEW_SUBSCRIPTION="<MY_NEW_SUBSCRIPTION>";
$MY_NEW_KEYVAULT="<MY_NEW_KEYVAULT>";

if (!(Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Error "CLI Azure is mandatory"
    exit
}

# Case n°1. $SECRETS can be either provided values as follow:
$SECRETS = @(
    #"secret-1",
    #"secret-2",
    #(...)
    #"secret-n"
)

# Case n°2. The list of secrets is herited from a specified Azure Key Vault:
if ($SECRETS.Count -eq 0) {
    az account set -s $MY_OLD_SUBSCRIPTION
    $SECRETS = az keyvault secret list --vault-name $MY_OLD_KEYVAULT --query [].name -o tsv
}

foreach ($secret_name in $SECRETS) {
    az account set -s $MY_OLD_SUBSCRIPTION
    $secret_value = (az keyvault secret show --vault-name $MY_OLD_KEYVAULT --name $secret_name --query value -o tsv)

    Write-Host "Migrating secret: $secret_name ...";

    if (!$secret_value) {
        Write-Warning "Unable to download secret '$secret_name' from Key Vault '$MY_OLD_KEYVAULT'"
        continue
    }

    az account set -s $MY_NEW_SUBSCRIPTION
    az keyvault secret set --vault-name $MY_NEW_KEYVAULT --name $secret_name --value "$secret_value"
}
