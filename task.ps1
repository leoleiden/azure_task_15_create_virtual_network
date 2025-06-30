$location = "uksouth"
$resourceGroupName = "mate-azure-task-15"

$virtualNetworkName = "todoapp"
$vnetAddressPrefix = "10.20.30.0/24"
$webSubnetName = "webservers"
$webSubnetIpRange = "10.20.30.0/26"  # 62 available IPs (64 total)
$dbSubnetName = "database"
$dbSubnetIpRange = "10.20.30.64/26"   # 62 available IPs (64 total)
$mngSubnetName = "management"
$mngSubnetIpRange = "10.20.30.128/26" # 62 available IPs (64 total)

Write-Host "Creating a resource group $resourceGroupName ..."
New-AzResourceGroup -Name $resourceGroupName -Location $location

Write-Host "Creating a virtual network ..."
# Create virtual network configuration
$virtualNetwork = New-AzVirtualNetwork `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -Name $virtualNetworkName `
  -AddressPrefix $vnetAddressPrefix

# Add subnets to the virtual network
Add-AzVirtualNetworkSubnetConfig `
  -Name $webSubnetName `
  -AddressPrefix $webSubnetIpRange `
  -VirtualNetwork $virtualNetwork | Out-Null

Add-AzVirtualNetworkSubnetConfig `
  -Name $dbSubnetName `
  -AddressPrefix $dbSubnetIpRange `
  -VirtualNetwork $virtualNetwork | Out-Null

Add-AzVirtualNetworkSubnetConfig `
  -Name $mngSubnetName `
  -AddressPrefix $mngSubnetIpRange `
  -VirtualNetwork $virtualNetwork | Out-Null

# Save the virtual network configuration
$virtualNetwork | Set-AzVirtualNetwork | Out-Null

Write-Host "Virtual network '$virtualNetworkName' created with 3 subnets"
