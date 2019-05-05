[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [String]$admin_password,
  [Parameter(Mandatory=$True)]
  [String]$domain,
  [Parameter(Mandatory=$True)]
  [String]$netbios_domain_name,
  [Parameter(Mandatory=$True)]
  [Boolean]$allow_reboot=$true,
  [Boolean]$install_dns=$true
)

try {
  if (((Get-CimInstance -ClassName Win32_OperatingSystem).ProductType -ne 2) -and (get-adforest -Identity $domain).Name -ne $domain) {
    install-windowsfeature AD-Domain-Services

    install-windowsfeature RSAT-ADDS
  
    $secureString = ConvertTo-SecureString $admin_password -AsPlainText -Force
  
    Install-ADDSForest -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainName $domain.ToLower() -DomainNetbiosName netbios_domain_name.ToUpper() -ForestMode "7" -InstallDns:$install_dns -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$allow_reboot -SysvolPath "C:\Windows\SYSVOL" -Force:$true -safeModeAdministratorPassword $secureString
  } else {
    Write-Host "Domain exists and node is a Domain Controller"
  }
}
catch {
  Write-Host "An error occurred:"
  Write-Host $_
}