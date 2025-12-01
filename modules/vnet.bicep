
@description('Accepts an existing virtual network id and exposes it for other modules.')
param virtualNetworkId string

// Return the provided VNet id - placeholder module to keep modular structure
output virtualNetworkId string = virtualNetworkId
