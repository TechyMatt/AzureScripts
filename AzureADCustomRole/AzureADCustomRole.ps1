## This Script is used to capture the current logged on user in the Azure Cloud Shell and executes a REST API call against the Azure AD role definition Graph API. It does NOT require an Application Account or SP to be created in Azure AD.

$resourceURI = "https://graph.microsoft.com/"
$tokenAuthURI = "http://localhost:50342/oauth2/token?resource=$resourceURI&api-version=2019-08-01"
$tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Metadata"="true"} -Uri $tokenAuthURI
$accessToken = $tokenResponse.access_token

$templateId = (New-Guid).Guid
$displayName = "Demo AzureAD RBAC"
$description = "Demo AzureAD RBAC Description"

$jsonPayload = @"
{
   "description": "$description",
   "displayName": "$displayName",
   "isEnabled": true,
   "templateId": "$templateId",
   "rolePermissions": [
       {
           "allowedResourceActions": [
               "microsoft.directory/applications/basic/update",
               "microsoft.directory/applications/credentials/update"
           ]
       }
   ]
}
"@

$params = @{
    Uri         = 'https://graph.microsoft.com/beta/roleManagement/directory/roleDefinitions'
    Headers     = @{
    'Content-Type'='application/json'
    'Authorization'='Bearer ' + $accessToken }
    Method      = 'POST'
    Body        = $jsonPayload
    ContentType = 'application/json'
}

Invoke-RestMethod @params
 
