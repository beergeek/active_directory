# active_directory::rsat_dns
#
# A class to manage the Remote Server Administration Tools for DNS Server
#
# @summary A class to manage the Remote Server Administration Tools
#
# @example
# include active_directory::rsat_dns
#
#
class active_directory::rsat_dns {

  if !($facts['os']['family'] == 'windows' and $facts['os']['release']['major'] =~ /2012 R2|2016|2019|2022/) {
    fail("This class is for Windows 2012 R2, 2016, 2019, and 2022, not ${facts['os']['family']} and ${facts['os']['release']['major']}")
  }

  dsc_windowsfeature { 'rsat-dns-server':
    dsc_ensure => present,
    dsc_name   => 'RSAT-DNS-Server',
  }

}
