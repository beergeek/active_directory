# active_directory::dns_server
#
# A class to manage DNS servers on Windows 2012 R2 and 2016
#
# @summary A class to manage DNS servers on Windows 2012 R2 and 2016
#
# @param dns_server_name DNS Server name.
# @param listening_addresses A comma separated string of addresses
# @param forwarders A comma separated string of addresses

class active_directory::dns_server (
  String $dns_server_name,
  String $listening_addresses = $facts['networking']['ip'],
  Optional[String] $forwarders = undef,
) {

  if !($facts['os']['family'] == 'windows' and $facts['os']['release']['major'] =~ /2012 R2|2016/) {
    fail("This class is for Windows 2012 R2 and 2016, not ${facts['os']['family']} and ${facts['os']['release']['major']}")
  }

  dsc_windowsfeature { 'dns':
    dsc_ensure => present,
    dsc_name   => 'dns',
  }

  dsc_xdnsserveraddress { 'dnsserveraddress':
    dsc_address        => '127.0.0.1',
    dsc_interfacealias => 'ethernet',
    dsc_addressfamily  => 'ipv4',
    require            => Dsc_windowsfeature['dns'],
  }

  dsc_xdnsserversetting { "${dns_server_name}_dns_server":
    dsc_name                      => "${dns_server_name}_dns_server",
    dsc_addressanswerlimit        => '10',
    dsc_allowupdate               => true,
    dsc_autocacheupdate           => false,
    dsc_autoconfigfilezones       => 1,
    dsc_bindsecondaries           => false,
    dsc_bootmethod                => '3',
    dsc_enabledirectorypartitions => true,
    dsc_enablednssec              => true,
    dsc_enableednsprobes          => true,
    dsc_eventloglevel             => '4',
    dsc_forwarddelegations        => false,
    dsc_forwarders                => $forwarders,
    dsc_forwardingtimeout         => '5',
    dsc_listenaddresses           => $listening_addresses,
    dsc_localnetpriority          => true,
    dsc_logfilemaxsize            => '',
    dsc_logfilepath               => '',
    dsc_logipfilterlist           => '',
    dsc_loglevel                  => '',
    dsc_loosewildcarding          => false,
    dsc_maxcachettl               => '',
    dsc_maxnegativecachettl       => '',
    dsc_namecheckflag             => '2',
    dsc_norecursion               => '',
    dsc_recursionretry            => '',
    dsc_recursiontimeout          => '',
    dsc_roundrobin                => true,
    dsc_rpcprotocol               => '5',
    dsc_scavenginginterval        => '01:00:00',
    dsc_secureresponses           => '',
    dsc_sendport                  => '0',
    dsc_strictfileparsing         => false,
    dsc_updateoptions             => '783',
    dsc_writeauthorityns          => '',
    dsc_xfrconnecttimeout         => '30',
  }
}
