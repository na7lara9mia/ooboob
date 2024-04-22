# Define your Azure subscription ID
$subscriptionId = "YOUR_SUBSCRIPTION_ID"

# Define your Azure budget details
$budgetName = "YOUR_BUDGET_NAME"
$resourceGroupName = "YOUR_RESOURCE_GROUP_NAME"
$budgetThreshold = 1000 # Adjust this value to your specific threshold amount

# Define your Data Factory details
$dataFactoryName = "YOUR_DATA_FACTORY_NAME"
$triggerName = "YOUR_TRIGGER_NAME"

# Set Azure context
az account set --subscription $subscriptionId

# Get current usage and amount spent against the budget
$usage = az consumption usage list --query "[?name.value=='$budgetName'].{Amount:usageAmount}" --output tsv
$amountSpent = [decimal]$usage

# Check if the amount spent exceeds the threshold
if ($amountSpent -ge $budgetThreshold) {
    # Disable the Data Factory trigger
    az datafactory trigger update --factory-name $dataFactoryName --resource-group-name $resourceGroupName --name $triggerName --status Disabled

    Write-Host "Data Factory trigger '$triggerName' disabled because the budget threshold of $budgetThreshold was reached."
} else {
    Write-Host "Budget is below the threshold. No action needed."
}
