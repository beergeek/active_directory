# active_directory::dns_server
#
# A class to manage DNS servers on Windows 2012 R2 and 2016
#
# @summary A class to manage DNS servers on Windows 2012 R2 and 2016
#
# @param dns_server_name DNS Server name.
# @param eventloglevel Determines which DNS events go to the Event Viewr. '0' None, '1' Errors only, '2' Errors and warnings, '4' All events.
# @param listening_addresses A comma separated string of listening addresses.
# @param forwarders A comma separated string of fowarder addresses.
# @param addressanswerlimit Number of addresses the server will return, 0 is unlimited or a  range is 5 to 28.
# @param roundrobin Indicates whether the DNS Server round robins multiple A records.
# @param allowupdate Specifies whether the DNS Server accepts dynamic update requests.
# @param autocacheupdate Indicates whether the DNS Server attempts to update its cache entries using data from root servers.
# @param autoconfigfilezones Indicates which standard primary zones that are authoritative for the name of the DNS Server must be updated when the name server changes.
# @param forwardingtimeout Time, in seconds, a DNS Server forwarding a query will wait for resolution from the forwarder before attempting to resolve the query itself.
# @param bindsecondaries Enables the DNS server to communicate with non-Microsoft DNS servers that use DNS BIND service.
# @param enabledirectorypartitions Specifies whether support for application directory partitions is enabled on the DNS Server.
# @param localnetpriority Determines the order in which the DNS server returns A records when it has multiple A records for the same name.
# @param logfilemaxsize Size of the DNS Server debug log, in bytes.
# @param logfilepath File name and path for the DNS Server debug log.
# @param logipfilterlist List of IP addresses used to filter DNS events written to the debug log.
# @param loosewildcarding Indicates whether the DNS Server performs loose wildcarding.
# @param maxcachettl Maximum time, in seconds, the record of a recursive name query may remain in the DNS Server cache.
# @param maxnegativecachettl Maximum time, in seconds, a name error result from a recursive query may remain in the DNS Server cache.
# @param namecheckflag Indicates the set of eligible characters to be used in DNS names.
# @param norecursion Indicates whether the DNS Server performs recursive look ups.
# @param recursionretry Elapsed seconds before retrying a recursive look up
# @param rpcprotocol RPC protocol or protocols over which administrative RPC runs (bitmap value).
# @param scavenginginterval Interval, in hours, between two consecutive scavenging operations performed by the DNS Server.
# @param secureresponses Indicates whether the DNS Server exclusively saves records of names in the same subtree as the server that provided them.
# @param sendport Port on which the DNS Server sends UDP queries to other servers.
# @param strictfileparsing Indicates whether the DNS Server parses zone files strictly.
# @param updateoptions Restricts the type of records that can be dynamically updated on the server, used in addition to the AllowUpdate settings on Server and Zone objects.
# @param writeauthorityns Specifies whether the DNS Server writes NS and SOA records to the authority section on successful response.
# @param xfrconnecttimeout Time, in seconds, the DNS Server waits for a successful TCP connection to a remote server when attempting a zone transfer.

class active_directory::dns::dns_server (
  String $dns_server_name,
  Active_directory::Bootmethod $bootmethod                  = '3',
  Active_directory::Loglevels $eventloglevel                = '4',
  Active_directory::Addressanswerlimit $addressanswerlimit  = '0',
  String $listening_addresses                               = $facts['networking']['ip'],
  Active_directory::Zero_one $roundrobin                    = '1',
  Active_directory::Zero_one $allowupdate                   = '1',
  Active_directory::Zero_one $enablednssec                  = '1',
  Active_directory::Zero_one $enableednsprobes              = '1',
  Active_directory::Zero_one $forwarddelegations            = '0',
  Boolean $autocacheupdate                                  = false,
  Integer $autoconfigfilezones                              = 1,
  Integer $forwardingtimeout                                = 3,
  Boolean $bindsecondaries                                  = false,
  Boolean $enabledirectorypartitions                        = true,
  Boolean $localnetpriority                                 = true,
  Integer $logfilemaxsize                                   = 500000000,
  String $logfilepath                                       = '%SystemRoot%\System32\DNS\Dns.log',
  Optional[Variant[Array[String],String]] $logipfilterlist  = undef,
  Boolean $loosewildcarding                                 = false,
  Integer $maxcachettl                                      = 86400,
  Integer $maxnegativecachettl                              = 900,
  Integer $namecheckflag                                    = 2,
  Boolean $norecursion                                      = false,
  Integer $recursionretry                                   = 3,
  Integer $recursiontimeout                                 = 8,
  Integer $rpcprotocol                                      = 5,
  Integer $scavenginginterval                               = 1,
  Boolean $secureresponses                                  = false,
  Integer $sendport                                         = 0,
  Boolean $strictfileparsing                                = false,
  Integer $updateoptions                                    = 783,
  Boolean $writeauthorityns                                 = false,
  Integer $xfrconnecttimeout                                = 30,
  Optional[String] $forwarders                              = undef,
) {

  if !($facts['os']['family'] == 'windows' and $facts['os']['release']['major'] =~ /2012 R2|2016/) {
    fail("This class is for Windows 2012 R2 and 2016, not ${facts['os']['family']} and ${facts['os']['release']['major']}")
  }

  dsc_xdnsserversetting { "${dns_server_name}_dns_server":
    dsc_name                      => "${dns_server_name}_dns_server",
    dsc_addressanswerlimit        => $addressanswerlimit,
    dsc_allowupdate               => $allowupdate,
    dsc_autocacheupdate           => $autocacheupdate,
    dsc_autoconfigfilezones       => $autoconfigfilezones,
    dsc_bindsecondaries           => $bindsecondaries,
    dsc_bootmethod                => $bootmethod,
    dsc_enabledirectorypartitions => $enabledirectorypartitions,
    dsc_enablednssec              => $enablednssec,
    dsc_enableednsprobes          => $enableednsprobes,
    dsc_eventloglevel             => $eventloglevel,
    dsc_forwarddelegations        => $forwarddelegations,
    dsc_forwarders                => $forwarders,
    dsc_forwardingtimeout         => $forwardingtimeout,
    dsc_listenaddresses           => $listening_addresses,
    dsc_localnetpriority          => $localnetpriority,
    dsc_logfilemaxsize            => $logfilemaxsize,
    dsc_logfilepath               => $logfilepath,
    dsc_logipfilterlist           => $logipfilterlist,
    dsc_loosewildcarding          => $loosewildcarding,
    dsc_maxcachettl               => $maxcachettl,
    dsc_maxnegativecachettl       => $maxnegativecachettl,
    dsc_namecheckflag             => $namecheckflag,
    dsc_norecursion               => $norecursion,
    dsc_recursionretry            => $recursionretry,
    dsc_recursiontimeout          => $recursiontimeout,
    dsc_roundrobin                => $roundrobin,
    dsc_rpcprotocol               => $rpcprotocol,
    dsc_scavenginginterval        => $scavenginginterval,
    dsc_secureresponses           => $secureresponses,
    dsc_sendport                  => $sendport,
    dsc_strictfileparsing         => $strictfileparsing,
    dsc_updateoptions             => $updateoptions,
    dsc_writeauthorityns          => $writeauthorityns,
    dsc_xfrconnecttimeout         => $xfrconnecttimeout,
  }
}
