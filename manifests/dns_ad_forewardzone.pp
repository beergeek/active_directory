
define active_directory::dns_ad_forewardzone (
  String $domain_credential_user,
  String $domain_credential_passwd,
  Active_directory::Replicationscope $replicationscope  = 'Forest',
  Active_directory::Dynamicupdate $dynamicupdate        = 'Secure',
  Optional[String] $directorypartitionname              = undef,
) {

  if !($facts['os']['family'] == 'windows' and $facts['os']['release']['major'] =~ /2012 R2|2016/) {
    fail("This class is for Windows 2012 R2 and 2016, not ${facts['os']['family']} and ${facts['os']['release']['major']}")
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
