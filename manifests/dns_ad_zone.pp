# active_directory::dns_ad_zone
#
# @summary Defined type to manage DNS Active Directory Zones.
#
# @param domain_credential_user The username for a user that has/will have domain administrator rights.
# @param domain_credential_passwd The password for the user that has/will have domain admininstrator rights.
# @param replicationscope Scope of replication for zone. Can be "Custom", "custom", "Domain", "domain", "Forest", "forest", "Legacy", or "legacy"
# @param dynamicupdate Determine how updates are performed. Can be "None", "none", "NonsecureAndSecure", "nonsecureandsecure", "Secure", or "secure"
# @param directorypartitionname Name of directory partition. 
#
# @example
#   active_directory::dns_ad_zone { 'puppet.local':
#     domain_credential_user   => 'Administrator',
#     domain_credential_passwd => "P00rP@ssword123',
#     replicationscope         => 'Forest',
#     dynamicupdate            => 'Secure',
#   }
#
define active_directory::dns_ad_zone (
  String $domain_credential_user,
  String $domain_credential_passwd,
  Active_directory::Replicationscope $replicationscope  = 'Forest',
  Active_directory::Dynamicupdate $dynamicupdate        = 'Secure',
  Optional[String] $directorypartitionname              = undef,
) {

  if !($facts['os']['family'] == 'windows' and $facts['os']['release']['major'] =~ /2012 R2|2016|2019/) {
    fail("This class is for Windows 2012 R2, 2016 and 2019, not ${facts['os']['family']} and ${facts['os']['release']['major']}")
  }

  $domain_credentials = {
    'user'     => $domain_credential_user,
    'password' => $domain_credential_passwd,
  }

  dsc_xdnsserveradzone { $title:
    dsc_ensure                 => present,
    dsc_name                   => $title,
    dsc_dynamicupdate          => $dynamicupdate,
    dsc_psdscrunascredential   => $domain_credentials,
    dsc_replicationscope       => $replicationscope,
    dsc_directorypartitionname => $directorypartitionname,
  }
}
