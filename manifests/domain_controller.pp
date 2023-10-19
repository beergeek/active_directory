# active_directory::domain_controller
#
# This class manages Forest and child domain controllers.
#
# @summary This class manages Forest and child domain controllers. It can also manage AD users.
#
# @param domain_credential_user The username for a user that has/will have domain administrator rights.
# @param domain_credential_passwd The password for the user that has/will have domain admininstrator rights.
# @param safe_mode_passwd The password for safe mode. The user for this is set to 'Admininstrator'.
# @param domain_name The name of he domain to be managed.
# @param ad_creation_retry_attempts The number of times a non-Forest domain controller will attempt to contact the Forest controller to
#   attempt domain creation.
# @param ad_creation_retry_interval The interval between attempts that the non-Forest domain controller will attempt to contact the Forest
#   controller.
# @param ad_db_path The path where the Active Directory Database will be created/managed.
# @param ad_log_path The log path for Active Directory logs.
# @param ad_users A hash of Active Directory users to create. Must bw of the type `dsc_xaduser`.
# @param parent_dns_addr IP address of parent DNS server.
# @param parent_domain_name The name of the parent domain this domain will belong to. Not required for a new Forest.
# @param sysvol_path The system volumne path for Active Directory.
#
# @example Create a new Forest domain controller.
#
# active_directory::domain_controller { 'first_AD':
#   domain_name              => 'puppet.local',
#   domain_credential_user   => 'Administrator',
#   domain_credential_passwd => 'THis_should_be_nbetter',
#   safe_mode_passwd         => 'safe_P@ssw0rd',
# }
#
class active_directory::domain_controller (
  Sensitive[String[1]] $domain_credential_passwd,
  String               $domain_credential_user,
  String               $domain_name,
  Sensitive[String[1]] $safe_mode_passwd,

  # Uses hiera for defaults
  Optional[Hash]       $ad_users,
  Optional[String]     $parent_dns_addr,
  Optional[String]     $parent_domain_name,
  String               $ad_creation_retry_attempts,
  String               $ad_creation_retry_interval,
  Stdlib::AbsolutePath $ad_db_path,
  Stdlib::AbsolutePath $ad_log_path,
  Stdlib::AbsolutePath $sysvol_path,
) {

  if !($facts['os']['family'] == 'windows' and $facts['os']['release']['major'] =~ /2012 R2|2016|2019|2022/) {
    fail("This class is for Windows 2012 R2, 2016, 2019 and 2022, not ${facts['os']['family']} and ${facts['os']['release']['major']}")
  }

  require active_directory::rsat_ad

  $_domain_credentials = {
    'user'     => $domain_credential_user,
    'password' => $domain_credential_passwd,
  }

  $_safemode_credentials = {
    'user'     => 'Administrator',
    'password' => $safe_mode_passwd,
  }

  if $parent_domain_name {

    if $facts['domain'] == $domain_name {
      $dns_array = ['127.0.0.1',$parent_dns_addr]
    } else {
      $dns_array = $parent_dns_addr
    }

    dsc_windowsfeature { 'dns':
      dsc_ensure => present,
      dsc_name   => 'dns',
    }

    dsc_dnsserveraddress { 'dnsserveraddress':
      dsc_address        => $dns_array,
      dsc_interfacealias => 'ethernet',
      dsc_addressfamily  => 'ipv4',
      require            => Dsc_windowsfeature['dns'],
    }

    dsc_xwaitforaddomain { $parent_domain_name:
      dsc_domainname           => $parent_domain_name,
      dsc_domainusercredential => $_domain_credentials,
      dsc_retryintervalsec     => $ad_creation_retry_interval,
      dsc_retrycount           => $ad_creation_retry_attempts,
      before                   => Dsc_xaddomain[$domain_name],
    }
  }

  dsc_windowsfeature { 'ADDSInstall':
    dsc_ensure => present,
    dsc_name   => 'AD-Domain-Services',
  }

  dsc_xaddomain { $domain_name:
    dsc_domainname                    => $domain_name,
    dsc_parentdomainname              => $parent_domain_name,
    dsc_domainadministratorcredential => $_domain_credentials,
    dsc_safemodeadministratorpassword => $_safemode_credentials,
    dsc_databasepath                  => $ad_db_path,
    dsc_sysvolpath                    => $sysvol_path,
    dsc_logpath                       => $ad_log_path,
    require                           => Dsc_windowsfeature['ADDSInstall'],
  }

  if $ad_users and !empty($ad_users) {
    $ad_users.each |String $ad_user,Hash $ad_user_data| {
      dsc_xaduser { $ad_user:
        *                                   => $ad_user_data,;
        default:
          dsc_domainname                    => $domain_name,
          dsc_domainadministratorcredential => $_domain_credentials,
          dsc_username                      => $ad_user,
          require                           => Dsc_xaddomain[$domain_name];
      }
    }
  }
}
