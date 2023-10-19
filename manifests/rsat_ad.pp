# active_directory::rsat_ad
#
# A class to manage the Remote Server Administration Tools for Active Directory
#
# @summary A class to manage the Remote Server Administration Tools
#
# @example
# include active_directory::rsat_ad
#
#
class active_directory::rsat_ad {

  if !($facts['os']['family'] == 'windows' and $facts['os']['release']['major'] =~ /2012 R2|2016|2019|2022/) {
    fail("This class is for Windows 2012 R2, 2016, 2019, and 2022, not ${facts['os']['family']} and ${facts['os']['release']['major']}")
  }

  dsc_windowsfeature { 'rsat-adds':
    dsc_ensure => present,
    dsc_name   => 'RSAT-ADDS',
  }

  dsc_windowsfeature { 'rsat-ad-tools':
    dsc_ensure => present,
    dsc_name   => 'RSAT-AD-Tools',
  }

  dsc_windowsfeature { 'rsat-adds-tools':
    dsc_ensure => present,
    dsc_name   => 'RSAT-ADDS-Tools',
  }
}
