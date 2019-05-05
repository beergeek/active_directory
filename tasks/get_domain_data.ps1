[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [String]$domain_name
)

try {
  Get-ADDomain
  Get-ADForest -Identity $domain_name
}
catch {
  'Failed'
}
