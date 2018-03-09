
# active_directory


#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with activedirectory](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with active_directory](#beginning-with-active_directory)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

A module to manage some Active Directory services, such as Domain Controllers and DNS Servers. Uses Microsoft DSC as the engine for management via Puppet.

## Setup

### Setup Requirements

None. Requires only the DSC module.

### Beginning with active_directory

Manage Domain Controllers and DNS Servers.

<span style="color:red;font-weight:bold">WARNING: due to bug with DSC xdnsserver module the `active_directory::dns_ad_zone` defined type does not function https://github.com/PowerShell/xDnsServer/issues/53</span>

## Usage

To manage ai Forest Domain Controller the following can be used:

```puppet
class { 'active_directory::domain_controller':
  domain_name               => 'puppet.local',
  domain_credential_user    => 'Administrator',
  domain_credential_passwd  => 'P00rP@ssword123',
  safe_mode_passwd          => 'Th!s1sSAfe',
}
```

To manage a child Domain Controller the followin can be used:

```puppet
class { 'active_directory::domain_controller':
  domain_name               => 'apac.puppet.local',
  domain_credential_user    => 'Administrator',
  domain_credential_passwd  => 'P00rP@ssword123',
  parent_dns_addr           => '192.168.0.10',
  parent_domain_name        => 'puppet.local',
  safe_mode_passwd          => 'Th!s1sSAfe',
}
```

Active Directory users can be manage with the `active_directory::domain_controller` class as well via the `ad_users` parameter. This hash needs to be in the format of `dsc_xaduser` resource type.

To manage a DNS server the following can be used:

```puppet
class { 'active_directory::dns_server':
  dns_server_name => 'dns0.puppet.local',
}
```

This will use default settings for the DNS server. There are plenty of options for the DNS server as described in the following paragraphs.

## Reference

## Classes
* [`active_directory::dns_server`](#active_directorydns_server): A class to manage DNS servers on Windows 2012 R2 and 2016
* [`active_directory::domain_controller`](#active_directorydomain_controller): This class manages Forest and child domain controllers. It can also manage AD users.
* [`active_directory::rsat_ad`](#active_directoryrsat_ad): A class to manage the Remote Server Administration Tools
* [`active_directory::rsat_dns`](#active_directoryrsat_dns): A class to manage the Remote Server Administration Tools
## Defined types
* [`active_directory::dns_ad_zone`](#active_directorydns_ad_zone): Defined type to manage DNS Active Directory Zones.
## Classes

### active_directory::dns_server

active_directory::dns_server

A class to manage DNS servers on Windows 2012 R2 and 2016

#### Examples
#####
```puppet
class { 'active_directory::dns_server':
  dns_server_name => 'dns0.puppet.local',
}
```


#### Parameters

The following parameters are available in the `active_directory::dns_server` class.

##### `dns_server_name`

Data type: `String`

DNS Server name.

##### `addressanswerlimit`

Data type: `Active_directory::Addressanswerlimit`

Number of addresses the server will return, 0 is unlimited or a  range is 5 to 28.

Default value: '0'

##### `allowupdate`

Data type: `Active_directory::Zero_one`

Specifies whether the DNS Server accepts dynamic update requests.

Default value: '1'

##### `autocacheupdate`

Data type: `Boolean`

Indicates whether the DNS Server attempts to update its cache entries using data from root servers.

Default value: `false`

##### `autoconfigfilezones`

Data type: `Integer`

Indicates which standard primary zones that are authoritative for the name of the DNS Server must be updated when the name server changes.

Default value: 1

##### `bindsecondaries`

Data type: `Boolean`

Enables the DNS server to communicate with non-Microsoft DNS servers that use DNS BIND service.

Default value: `false`

##### `bootmethod`

Data type: `Active_directory::Bootmethod`

Determines the source of information that the DNS server uses to start, such as settings to configure the DNS Service, a list of authoritative zones, and configuration settings for the zones.

Default value: '3'

##### `enabledirectorypartitions`

Data type: `Boolean`

Specifies whether support for application directory partitions is enabled on the DNS Server.

Default value: `true`

##### `enablednssec`

Data type: `Active_directory::Zero_one`

Specifies whether the DNS Server includes DNSSEC-specific RRs, KEY, SIG, and NXT in a response.

Default value: '1'

##### `enableednsprobes`

Data type: `Active_directory::Zero_one`

Specifies the behavior of the DNS Server. When TRUE, the DNS Server always responds with OPT resource records according to RFC 2671, unless the remote server has indicated it does not support EDNS in a prior exchange. If FALSE, the DNS Server responds to queries with OPTs only if OPTs are sent in the original query.

Default value: '1'

##### `eventloglevel`

Data type: `Active_directory::Loglevels`

Determines which DNS events go to the Event Viewr. '0' None, '1' Errors only, '2' Errors and warnings, '4' All events.

Default value: '4'

##### `forwarddelegations`

Data type: `Active_directory::Zero_one`

Specifies whether queries to delegated sub-zones are forwarded

Default value: '0'

##### `forwarders`

Data type: `Optional[String]`

A comma separated string of fowarder addresses.

Default value: `undef`

##### `forwardingtimeout`

Data type: `Integer`

Time, in seconds, a DNS Server forwarding a query will wait for resolution from the forwarder before attempting to resolve the query itself.

Default value: 3

##### `listening_addresses`

Data type: `String`

A comma separated string of listening addresses.

Default value: $facts['networking']['ip']

##### `localnetpriority`

Data type: `Boolean`

Determines the order in which the DNS server returns A records when it has multiple A records for the same name.

Default value: `true`

##### `logfilemaxsize`

Data type: `Integer`

Size of the DNS Server debug log, in bytes.

Default value: 500000000

##### `logfilepath`

Data type: `String`

File name and path for the DNS Server debug log.

Default value: '%SystemRoot%\System32\DNS\Dns.log'

##### `logipfilterlist`

Data type: `Optional[Variant[Array[String],String]]`

List of IP addresses used to filter DNS events written to the debug log.

Default value: `undef`

##### `loosewildcarding`

Data type: `Boolean`

Indicates whether the DNS Server performs loose wildcarding.

Default value: `false`

##### `maxcachettl`

Data type: `Integer`

Maximum time, in seconds, the record of a recursive name query may remain in the DNS Server cache.

Default value: 86400

##### `maxnegativecachettl`

Data type: `Integer`

Maximum time, in seconds, a name error result from a recursive query may remain in the DNS Server cache.

Default value: 900

##### `namecheckflag`

Data type: `Integer`

Indicates the set of eligible characters to be used in DNS names.

Default value: 2

##### `norecursion`

Data type: `Boolean`

Indicates whether the DNS Server performs recursive look ups.

Default value: `false`

##### `recursionretry`

Data type: `Integer`

Elapsed seconds before retrying a recursive look up

Default value: 3

##### `recursiontimeout`

Data type: `Integer`

Elapsed seconds before the DNS Server gives up recursive query.

Default value: 8

##### `roundrobin`

Data type: `Active_directory::Zero_one`

Indicates whether the DNS Server round robins multiple A records.

Default value: '1'

##### `rpcprotocol`

Data type: `Integer`

RPC protocol or protocols over which administrative RPC runs (bitmap value).

Default value: 5

##### `scavenginginterval`

Data type: `Integer`

Interval, in hours, between two consecutive scavenging operations performed by the DNS Server.

Default value: 1

##### `secureresponses`

Data type: `Boolean`

Indicates whether the DNS Server exclusively saves records of names in the same subtree as the server that provided them.

Default value: `false`

##### `sendport`

Data type: `Integer`

Port on which the DNS Server sends UDP queries to other servers.

Default value: 0

##### `strictfileparsing`

Data type: `Boolean`

Indicates whether the DNS Server parses zone files strictly.

Default value: `false`

##### `updateoptions`

Data type: `Integer`

Restricts the type of records that can be dynamically updated on the server, used in addition to the AllowUpdate settings on Server and Zone objects.

Default value: 783

##### `writeauthorityns`

Data type: `Boolean`

Specifies whether the DNS Server writes NS and SOA records to the authority section on successful response.

Default value: `false`

##### `xfrconnecttimeout`

Data type: `Integer`

Time, in seconds, the DNS Server waits for a successful TCP connection to a remote server when attempting a zone transfer.

Default value: 30


### active_directory::domain_controller

active_directory::domain_controller

This class manages Forest and child domain controllers.

attempt domain creation.
controller.

active_directory::domain_controller { 'first_AD':
  domain_name              => 'puppet.local',
  domain_credential_user   => 'Administrator',
  domain_credential_passwd => 'THis_should_be_nbetter',
  safe_mode_passwd         => 'safe_P@ssw0rd',
}

#### Examples
##### Create a new Forest domain controller.
```puppet

```


#### Parameters

The following parameters are available in the `active_directory::domain_controller` class.

##### `domain_credential_user`

Data type: `String`

The username for a user that has/will have domain administrator rights.

##### `domain_credential_passwd`

Data type: `String`

The password for the user that has/will have domain admininstrator rights.

##### `safe_mode_passwd`

Data type: `String`

The password for safe mode. The user for this is set to 'Admininstrator'.

##### `domain_name`

Data type: `String`

The name of he domain to be managed.

##### `ad_creation_retry_attempts`

Data type: `String`

The number of times a non-Forest domain controller will attempt to contact the Forest controller to

Default value: '5'

##### `ad_creation_retry_interval`

Data type: `String`

The interval between attempts that the non-Forest domain controller will attempt to contact the Forest

Default value: '5'

##### `ad_db_path`

Data type: `String`

The path where the Active Directory Database will be created/managed.

Default value: 'C:\Windows\NTDS'

##### `ad_log_path`

Data type: `String`

The log path for Active Directory logs.

Default value: 'C:\Windows\NTDS'

##### `ad_users`

Data type: `Optional[Hash]`

A hash of Active Directory users to create. Must bw of the type `dsc_xaduser`.

Default value: {}

##### `parent_dns_addr`

Data type: `Optional[String]`

IP address of parent DNS server.

Default value: `undef`

##### `parent_domain_name`

Data type: `Optional[String]`

The name of the parent domain this domain will belong to. Not required for a new Forest.

Default value: `undef`

##### `sysvol_path`

Data type: `String`

The system volumne path for Active Directory.

Default value: 'C:\Windows\SYSVOL'


### active_directory::rsat_ad

active_directory::rsat_ad

A class to manage the Remote Server Administration Tools for Active Directory

include active_directory::rsat_ad


### active_directory::rsat_dns

active_directory::rsat_dns

A class to manage the Remote Server Administration Tools for DNS Server

include active_directory::rsat_dns


## Defined types

### active_directory::dns_ad_zone

active_directory::dns_ad_zone

<span style="color:red;font-weight:bold">WARNING: due to bug with DSC xdnsserver module the `active_directory::dns_ad_zone` defined type does not function https://github.com/PowerShell/xDnsServer/issues/53</span>

#### Examples
#####
```puppet
active_directory::dns_ad_zone { 'puppet.local':
  domain_credential_user   => 'Administrator',
  domain_credential_passwd => "P00rP@ssword123',
  replicationscope         => 'Forest',
  dynamicupdate            => 'Secure',
}
```


#### Parameters

The following parameters are available in the `active_directory::dns_ad_zone` defined type.

##### `domain_credential_user`

Data type: `String`

The username for a user that has/will have domain administrator rights.

##### `domain_credential_passwd`

Data type: `String`

The password for the user that has/will have domain admininstrator rights.

##### `replicationscope`

Data type: `Active_directory::Replicationscope`

Scope of replication for zone. Can be "Custom", "custom", "Domain", "domain", "Forest", "forest", "Legacy", or "legacy"

Default value: 'Forest'

##### `dynamicupdate`

Data type: `Active_directory::Dynamicupdate`

Determine how updates are performed. Can be "None", "none", "NonsecureAndSecure", "nonsecureandsecure", "Secure", or "secure"

Default value: 'Secure'

##### `directorypartitionname`

Data type: `Optional[String]`

Name of directory partition.

Default value: `undef`


## Limitations

Tested on Windows 2012R2.

## Development

Pull Requests welcome.

