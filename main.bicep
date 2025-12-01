
@description('Main orchestrator for Application Gateway (modular). Keeps original resource names/tags unchanged.')
param applicationGateways_FWCIDEVAPGW02_name string = 'FWCIDEVAPGW02'
param location string = 'eastus'

@description('Existing VNet resource id (use the same value exported)')
param virtualNetworks_FC_FWCI_VNET_DEV_EUS_externalid string

@description('Existing Public IP resource id (use the same value exported)')
param publicIPAddresses_FWCDEVAPGPIP01_externalid string

@description('Existing WAF policy resource id (use the same value exported)')
param ApplicationGatewayWebApplicationFirewallPolicies_FWCIDEVGWPOLICY_externalid string

@description('Log Analytics workspace resource id for diagnostics (optional)')
param logAnalyticsWorkspaceId string = ''

module vnetModule 'modules/vnet.bicep' = {
  name: 'vnetModule'
  params: {
    virtualNetworkId: virtualNetworks_FC_FWCI_VNET_DEV_EUS_externalid
  }
}

module publicIpModule 'modules/publicIP.bicep' = {
  name: 'publicIpModule'
  params: {
    publicIpId: publicIPAddresses_FWCDEVAPGPIP01_externalid
  }
}

module appgw 'modules/appgw.bicep' = {
  name: 'appgw'
  params: {
    applicationGatewayName: applicationGateways_FWCIDEVAPGW02_name
    location: location
    virtualNetworkId: virtualNetworks_FC_FWCI_VNET_DEV_EUS_externalid
    publicIpId: publicIPAddresses_FWCDEVAPGPIP01_externalid
    wafPolicyId: ApplicationGatewayWebApplicationFirewallPolicies_FWCIDEVGWPOLICY_externalid
  }
}

module diag 'modules/diagnostics.bicep' = {
  name: 'diag'
  params: {
    targetResourceId: appgw.outputs.applicationGatewayId
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
  }
}

output applicationGatewayId string = appgw.outputs.applicationGatewayId
output applicationGatewayName string = appgw.outputs.applicationGatewayName
