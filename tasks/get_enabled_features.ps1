[CmdletBinding()]
Param()

try {
  Get-WindowsFeature  | Where Installed | Format-List -Property Name
}
catch {
  Write-Host "An error occurred:"
  Write-Host $_
}
