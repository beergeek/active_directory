[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [String]$ip,
  [Parameter(Mandatory=$True)]
  [String]$name,
  [Parameter(Mandatory=$True)]
  [String]$domain
)

try {
  Add-DnsServerResourceRecordA -Name $name -ZoneName $domain -AllowUpdateAny -IPv4Address $ip
}
catch {
  Write-Host "An error occurred:"
  Write-Host $_
}