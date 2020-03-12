# Manages domain controllers in a current domain
#
# @summary Manages domain controllers in a current domain
#
# @param domain_credential_user The username for a Domain Admin user that has have domain administrator rights.
# @param domain_credential_passwd The password of the Domain Admin user.
# @param domain_name The name of he domain to be managed.
# @param ad_db_path The path where the Active Directory Database will be created/managed.
# @param ad_log_path The log path for Active Directory logs.
# @param ad_users A hash of Active Directory users to create. Must bw of the type `dsc_xaduser`.
# @param parent_dns_addr IP address of parent DNS server.
# @param parent_domain_name The name of the parent domain this domain will belong to. Not required for a new Forest.
# @param sysvol_path The system volumne path for Active Directory.
# @param site_name The name of the site this Domain Controller will be added to.
# @param ad_wait_retry_attempts The number of times a non-Forest domain controller will attempt to contact the Forest controller to
#   join the domain.
# @param ad_wait_retry_interval The interval between attempts that the non-Forest domain controller will attempt to contact the Forest
#   controller before attempting to create the domain controller/
#
# @example Create a new Forest domain controller.
#
# active_directory::child_domain_controller { 'my_child':
#   domain_name              => 'puppet.local',
#   domain_credential_user   => 'Administrator',
#   domain_credential_passwd => 'THis_should_be_nbetter',
# }
class active_directory::child_domain_controller (
  String[1]                      $domain_name,
  String[1]                      $domain_credential_user,
  String[1]                      $domain_credential_passwd,

  # Use hiera for defaults
  Stdlib::AbsolutePath           $ad_db_path,
  Stdlib::AbsolutePath           $ad_log_path,
  Stdlib::AbsolutePath           $sysvol_path,
  String[1]                      $ad_wait_retry_attempts,
  String[1]                      $ad_wait_retry_interval,
  Optional[String[1]]            $site_name,
  Optional[Stdlib::AbsolutePath] $install_media_path,
){

  if !($facts['os']['family'] == 'windows' and $facts['os']['release']['major'] =~ /2012 R2|2016|2019/) {
    fail("This class is for Windows 2012 R2, 2016 and 2019, not ${facts['os']['family']} and ${facts['os']['release']['major']}")
  }

  require active_directory::rsat_ad

  $_domain_credentials = {
    'user'     => $domain_credential_user,
    'password' => Sensitive($domain_credential_passwd),
  }

  dsc_xwaitforaddomain { $domain_name:
    dsc_domainname           => $domain_name,
    dsc_domainusercredential => $_domain_credentials,
    dsc_retryintervalsec     => $ad_wait_retry_attempts,
    dsc_retrycount           => $ad_wait_retry_interval,
  }

  dsc_windowsfeature { 'ADDSInstall':
    dsc_ensure => present,
    dsc_name   => 'AD-Domain-Services',
  }

  dsc_xaddomaincontroller { 'child_comain':
    dsc_databasepath                  => $ad_db_path,
    dsc_domainadministratorcredential => $_domain_credentials,
    dsc_domainname                    => $domain_name,
    dsc_installationmediapath         => $install_media_path,
    dsc_logpath                       => $ad_log_path,
    dsc_sitename                      => $site_name,
    dsc_sysvolpath                    => $sysvol_path,
    require                           => [Dsc_xwaitforaddomain[$domain_name], Dsc_windowsfeature['ADDSInstall']]
  }

}
