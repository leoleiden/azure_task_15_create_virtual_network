```powershell
# Azure Virtual Network Deployment for TODO App

# Set variables for deployment
$location = "uksouth"
$resourceGroupName = "mate-azure-task-15"

$virtualNetworkName = "todoapp"
$vnetAddressPrefix = "10.20.30.0/24"

# Subnet configurations
$webSubnetName = "webservers"
$webSubnetIpRange = "10.20.30.0/26"
$dbSubnetName = "database"
$dbSubnetIpRange = "10.20.30.64/26"
$mngSubnetName = "management"
$mngSubnetIpRange = "10.20.30.128/26"

# Error handling and logging
$ErrorActionPreference = 'Stop'

try {
    # Ensure we're logged in to Azure
    $azContext = Get-AzContext
    if (-not $azContext) {
        Write-Error "Not logged in to Azure. Please run Connect-AzAccount first."
    }

    # Create resource group
    Write-Host "Creating resource group '$resourceGroupName' in '$location'..."
    New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

    # Create virtual network
    Write-Host "Creating virtual network '$virtualNetworkName'..."
    $virtualNetwork = New-AzVirtualNetwork `
        -ResourceGroupName $resourceGroupName `
        -Location $location `
        -Name $virtualNetworkName `
        -AddressPrefix $vnetAddressPrefix

    # Add subnets
    Write-Host "Adding subnets to virtual network..."
    $webSubnet = Add-AzVirtualNetworkSubnetConfig `
        -Name $webSubnetName `
        -AddressPrefix $webSubnetIpRange `
        -VirtualNetwork $virtualNetwork

    $dbSubnet = Add-AzVirtualNetworkSubnetConfig `
        -Name $dbSubnetName `
        -AddressPrefix $dbSubnetIpRange `
        -VirtualNetwork $virtualNetwork

    $mngSubnet = Add-AzVirtualNetworkSubnetConfig `
        -Name $mngSubnetName `
        -AddressPrefix $mngSubnetIpRange `
        -VirtualNetwork $virtualNetwork

    # Save network configuration
    $virtualNetwork | Set-AzVirtualNetwork | Out-Null

    # Prepare result object
    $result = @{
        virtualNetwork = @{
            name = $virtualNetworkName
            addressSpace = $vnetAddressPrefix
        }
        subnets = @(
            @{
                name = $webSubnetName
                addressRange = $webSubnetIpRange
            },
            @{
                name = $dbSubnetName
                addressRange = $dbSubnetIpRange
            },
            @{
                name = $mngSubnetName
                addressRange = $mngSubnetIpRange
            }
        )
    }

    # Save result to JSON
    $result | ConvertTo-Json -Depth 5 | Out-File -FilePath "result.json"

    Write-Host "Virtual network '$virtualNetworkName' created successfully with 3 subnets"
    Write-Host "Results saved to result.json"
}
catch {
    Write-Error "An error occurred: $_"
    throw
}
```
  
