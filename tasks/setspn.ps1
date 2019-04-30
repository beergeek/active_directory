[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [String]$service,
  [Parameter(Mandatory=$True)]
  [String]$fqdn,
  [Parameter(Mandatory=$True)]
  [String]$user,
)

try {
  setspn -S $service/$fqdn $user
}
catch {
  Write-Host "An error occurred:"
  Write-Host $_
}