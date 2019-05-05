[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [String]$new_hostname,
  [Parameter(Mandatory=$True)]
  [String]$new_domain_name
)

$domain = get-dnsclient -InterfaceAlias "Ethernet*" | Select -ExpandProperty  "ConnectionSpecificSuffix"
$restart = $False

if ($env:computername -ne $new_hostname.ToUpper()) {
  Rename-Computer -NewName $new_hostname
  $restart = $True
}

if ($domain -ne $new_domain_name) {
  $DNSSuffix = $new_domain_name

  get-dnsclient | set-dnsclient -ConnectionSpecificSuffix $DNSSuffix

  #Update primary DNS Suffix for FQDN
  Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\" -Name Domain -Value $DNSSuffix
  Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\" -Name "NV Domain" -Value $DNSSuffix
  $restart = $True
}

if ($restart -eq $True) {
  Restart-Computer -Force
}
