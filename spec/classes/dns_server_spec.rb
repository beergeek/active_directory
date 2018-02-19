require 'spec_helper'
describe 'active_directory::dns_server' do
  context 'with defaults and required for all parameters' do
    let :facts do
      {
        os: { 'family' => 'windows', 'release' => { 'major' => '2012 R2' } },
        networking: { 'ip' => '192.168.0.222' },
      }
    end
    let :params do
      {
        dns_server_name:    'tokyo_dns',
      }
    end

    it { is_expected.to compile }

    it { is_expected.to contain_class('active_directory::dns_server') }
  end
end
