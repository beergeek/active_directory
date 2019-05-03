[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [String]$admin_password,
  [Parameter(Mandatory=$True)]
  [String]$domain,
  [Parameter(Mandatory=$True)]
  [Boolean]$allow_reboot,
  [Parameter(Mandatory=$True)]
  [Boolean]$install_dns,
)

try {
  install-windowsfeature AD-Domain-Services

  install-windowsfeature RSAT-ADDS
  
  $secureString = ConvertTo-SecureString $admin_password -AsPlainText -Force
  
  Install-ADDSForest -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainName $domain.ToLower() -DomainNetbiosName "MONGODB" -ForestMode "7" -InstallDns:$install_dns -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$allow_reboot -SysvolPath "C:\Windows\SYSVOL" -Force:$true -safeModeAdministratorPassword $secureString
}
catch {
  Write-Host "An error occurred:"
  Write-Host $_
}