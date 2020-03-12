require 'spec_helper'

describe 'active_directory::child_domain_controller' do
  context 'with defaults and required for all parameters' do
    let :facts do
      {
        os: { 'family' => 'windows', 'release' => { 'major' => '2012 R2' } },
      }
    end
    let :params do
      {
        domain_credential_user:    'Admininstrator',
        domain_credential_passwd:  'vftybeisudvfkyj rtysaerfvacjtyDMZHfvfgty',
        domain_name:               'puppet.local',
      }
    end

    it { is_expected.to compile }

    it { is_expected.to contain_class('active_directory::child_domain_controller') }
  end
end
