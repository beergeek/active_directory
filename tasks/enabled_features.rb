#!/opt/puppetlabs/puppet/bin/ruby
require 'open3'
require 'json'

begin
  cmd_string = 'powershell -command "Get-WindowsFeature  | Where Installed | Format-List -Property Name"'
  stdout, stderr, status = Open3.capture3(cmd_string)
  raise 'Output not recognised', stderr if status != 0
  puts stdout.strip
  exit 0
rescue
  puts 'Output not recognised'
end
