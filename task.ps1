```powershell
$location = "uksouth"
$resourceGroupName = "mate-azure-task-15"

$virtualNetworkName = "todoapp"
$vnetAddressPrefix = "10.20.30.0/24"
$webSubnetName = "webservers"
$webSubnetIpRange = "10.20.30.0/26"
$dbSubnetName = "database"
$dbSubnetIpRange = "10.20.30.64/26"
$mngSubnetName = "management"
$mngSubnetIpRange = "10.20.30.128/26"
# 
Write-Host "Creating a resource group $resourceGroupName ..."
New-AzResourceGroup -Name $resourceGroupName -Location $location

Write-Host "Creating a virtual network ..."
$virtualNetwork = New-AzVirtualNetwork `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -Name $virtualNetworkName `
  -AddressPrefix $vnetAddressPrefix

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

$virtualNetwork | Set-AzVirtualNetwork | Out-Null

# Create result object
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

# Save to JSON
$result | ConvertTo-Json | Out-File -FilePath "result.json"

Write-Host "Virtual network '$virtualNetworkName' created with 3 subnets"
Write-Host "Results saved to result.json"
```
  
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
