#!/opt/puppetlabs/puppet/bin/ruby
require 'open3'
require 'json'

begin
  cmd_string = 'powershell -command "Get-ADDomain"'
  stdout, stderr, status = Open3.capture3(cmd_string)
  raise 'Output not recognised', stderr if status != 0
  puts stdout.strip
  exit 0
end
