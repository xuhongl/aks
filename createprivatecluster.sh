RGNAME=privateaks
LOCATION=westus2
AKSNAME=nfprivateaks
VNETNAME=aksprivate
SUBNET=AKS
az group create -n $RGNAME -l $LOCATION
az network vnet create -g $RGNAME -n $VNETNAME --address-prefix 10.0.0.0/16 \
    --subnet-name $SUBNET --subnet-prefix 10.0.0.0/22
SUBNETID=`az network vnet subnet show -n $SUBNET --vnet-name $VNETNAME -g $RGNAME --query id -o tsv`
az aks create \
    --resource-group $RGNAME \
    --name $AKSNAME \
    --load-balancer-sku standard \
    --enable-private-cluster \
    --network-plugin azure \
    --vnet-subnet-id $SUBNETID \
    --docker-bridge-address 172.17.0.1/16 \
    --dns-service-ip 10.2.0.10 \
    --service-cidr 10.2.0.0/24  
