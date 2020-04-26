# Login to az and set Azure subscription
$subscriptionId = '4a9ef912-a2e9-4795-b0ce-55b456fd2f6e'
az login
az account set --subscription $subscriptionId

# Create a service principal in this subscription and capture the properties that are output
az ad sp create-for-rbac --skip-assignment

# Copy spn property values here 
$spnAppId = "d17f18d5-b7e7-491b-9aae-02d3baca3401"
$spnAppPassword = "95dfd571-ee54-4af4-80b7-4a0b112faf25"

# Assign the spn to the Contributor role on the subscription (need permissions to create cluster resources in the subscription)
az role assignment create --role Contributor --assignee $spnAppId --scope '/subscriptions/4a9ef912-a2e9-4795-b0ce-55b456fd2f6e'

# Set the Azure location for the cluster. Supported locations during preview are (eastus, westeurope).
$location = 'eastus'

# Set the name for the resource group that will be created by the AKS Engine. The name must be unique within the subscription.
$resourceGroupName = "myAKS3akseng" 
$dnsPrefix = $resourceGroupName

# Set the local absolute file path of the API model (download this from https://github.com/Azure/aks-engine/blob/master/examples/kubernetes.json)
# For example, "C:\Users\<you>\aks-engine-v0.48.0-windows-amd64\kubernetes.json"
$apimodel = "C:\Users\xuhliu\Desktop\kubernetes.json"
# You can edit this file to modify the Kubernetes version size of VMs and the number of worker nodes (see example file below).

# Create the cluster
aks-engine deploy --subscription-id $subscriptionId --resource-group $resourceGroupName --client-id $spnAppId  --client-secret $spnAppPassword  --dns-prefix $dnsPrefix --location $location --api-model $apimodel --force-overwrite

# Verify that the cluster was created
# First set KUBECONFIG (AKS-Engine creates this file)
# Example: 'C:\Windows\System32\_output\<resource group name>\kubeconfig\kubeconfig.eastus.json'
# in your case, it will be a "_output" folder under the local directory where you create it
#$env:KUBECONFIG = <absolute file location>
#kubectl cluster-info
kubectl get nodes --kubeconfig=C:\Users\xuhliu\Desktop\_output\myAKS3akseng\kubeconfig\kubeconfig.eastus.json


