require 'spec_helper'
describe 'active_directory::domain_controller' do
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
        safe_mode_passwd:          'EvenW0rse%',
        domain_name:               'puppet.local',
      }
    end

    it { is_expected.to compile }

    it { is_expected.to contain_class('active_directory::domain_controller') }
  end
end
