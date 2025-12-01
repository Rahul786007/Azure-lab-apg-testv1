
@description('Create diagnostic settings for a target resource to send to Log Analytics.')
param targetResourceId string
param logAnalyticsWorkspaceId string

// if no workspace specified, skip (user can supply workspace id in parameters)
var enableDiagnostics = (logAnalyticsWorkspaceId != '')

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = if (enableDiagnostics) {
  name: last(split(logAnalyticsWorkspaceId, '/'))
  scope: resourceGroup(logAnalyticsWorkspaceId)
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics) {
  name: '${replace(split(targetResourceId, '/')[8], '-', '')}-diag'
  scope: resourceId(targetResourceId)
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    logs: [
      {
        category: 'ApplicationGatewayFirewallLog'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'ApplicationGatewayAccessLog'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'ApplicationGatewayPerformanceLog'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
}

output diagnosticSettingsName string = diagnosticSettings.name
