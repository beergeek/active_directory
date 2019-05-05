[CmdletBinding()]
Param()

try {
  Get-DNSServer
}
catch {
  Write-Host "An error occurred:"
  Write-Host $_
}