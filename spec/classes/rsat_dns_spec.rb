require 'spec_helper'
describe 'active_directory::rsat_dns' do
  context 'with defaults and required for all parameters' do
    let :facts do
      {
        os: { 'family' => 'windows', 'release' => { 'major' => '2012 R2' } },
      }
    end

    it { is_expected.to compile }

    it { is_expected.to contain_class('active_directory::rsat_dns') }
  end
end
