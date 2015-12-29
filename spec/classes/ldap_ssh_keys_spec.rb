require 'spec_helper'

describe 'ldap_ssh_keys', :type => 'class' do

  context "Should contain ssh-ldap-wrapper wrapper file" do

    let(:facts) {
      { :osfamily     => 'Debian' }
    }

    it do
      should contain_file('/usr/local/bin/ssh-ldap-wrapper').with(
            'owner'    => 'root',
            'group'    => 'root',
            'mode'     => '0755'
      )
      should_not contain_user('ssh-key-lookup')
    end
  end

  context "Should create the ssh-key-lookup user" do

    let(:params) {
      { :create_lookup_user    =>  true }
    }

    let(:facts) {
     { :osfamily     => 'Debian' }
    }

    it do
      should contain_user('ssh-key-lookup').with(
            'comment'  => 'SSH KEY Lookup User',
            'shell'    => '/usr/sbin/nologin',
            'home'     => '/dev/null'
      )
    end
  end

  context "Should contain openldap-clients package and ldap.conf RedHat systems" do

    let(:params) {
      { :create_ldap_config    =>  true }
    }

    let(:facts) {
     { :osfamily     => 'RedHat' }
    }

    it do
      should contain_file('/etc/openldap/ldap.conf').with(
            'owner'    => 'root',
            'group'    => 'root',
            'mode'     => '0644'
      )
      should_not contain_file('/etc/ldap/ldap.conf')
      should contain_package('openldap-clients').with(
            'ensure'   => 'installed',         
      )
      should_not contain_package('ldap-utils')
      should_not contain_user('ssh-key-lookup')
    end
  end

  context "Should contain openldap-clients package and ldap.conf Debian systems" do

    let(:params) {
      { :create_ldap_config    =>  true }
    }

    let(:facts) {
     { :osfamily     => 'Debian' }
    }

    it do
      should contain_file('/etc/ldap/ldap.conf').with(
            'owner'    => 'root',
            'group'    => 'root',
            'mode'     => '0644'
      )
      should_not contain_file('/etc/openldap/ldap.conf')
      should contain_package('ldap-utils').with(
            'ensure'   => 'installed',         
      )
      should_not contain_package('openldap-clients')
      should_not contain_user('ssh-key-lookup')
    end
  end

  context "Should fail with unsupported OS family" do

    let(:params) {
      { :create_ldap_config    =>  true }
    }

    let(:facts) {
     { :osfamily     => 'Solaris' }
    }

    it do
      should raise_error(Puppet::Error, /ldap_ssh_keys - Unsupported Operating System family: Solaris/)
    end
  end

end