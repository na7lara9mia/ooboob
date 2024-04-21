# Define your Azure subscription ID
$subscriptionId = "YOUR_SUBSCRIPTION_ID"

# Define your Azure budget details
$budgetName = "YOUR_BUDGET_NAME"
$resourceGroupName = "YOUR_RESOURCE_GROUP_NAME"
$budgetThreshold = 1000 # Adjust this value to your specific threshold amount

# Define your Data Factory details
$dataFactoryName = "YOUR_DATA_FACTORY_NAME"
$runId = "YOUR_DATA_FACTORY_RUN_ID"

# Set Azure context
az account set --subscription $subscriptionId

# Get current usage and amount spent against the budget
$usage = az consumption usage list --query "[?name.value=='$budgetName'].{Amount:usageAmount}" --output tsv
$amountSpent = [decimal]$usage

# Check if the amount spent exceeds the threshold
if ($amountSpent -ge $budgetThreshold) {
    # Stop the Data Factory run
    az datafactory pipeline run cancel --factory-name $dataFactoryName --run-id $runId --resource-group-name $resourceGroupName

    Write-Host "Data Factory run stopped because the budget threshold of $budgetThreshold was reached."
} else {
    Write-Host "Budget is below the threshold. No action needed."
}
