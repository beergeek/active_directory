[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [String]$safe_password,
  [Parameter(Mandatory=$True)]
  [String]$domain_name,
  [Parameter(Mandatory=$True)]
  [String]$netbios_domain_name
)

install-windowsfeature AD-Domain-Services

install-windowsfeature RSAT-ADDS

$secureString = ConvertTo-SecureString $safe_password -AsPlainText -Force
try {
  $forest_details = Get-ADForest -Identity $domain_name
}
catch {
  Install-ADDSForest -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainName $domain_name -DomainNetbiosName $netbios_domain_name.toUpper() -ForestMode "7" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -safeModeAdministratorPassword $secureString
}
