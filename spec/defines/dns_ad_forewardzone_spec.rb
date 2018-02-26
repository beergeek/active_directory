require 'spec_helper'

describe 'active_directory::dns_ad_forewardzone' do
    let(:title) { 'puppet.local' }
    let :facts do
      {
        os: { 'family' => 'windows', 'release' => { 'major' => '2012 R2' } },
      }
    end

    context 'with credentials' do
      let(:params) do
        {
          domain_credential_user: 'Administrator',
          domain_credential_passwd: 'passw0rd##',
        }
      end

      it { should compile }
    end
end
