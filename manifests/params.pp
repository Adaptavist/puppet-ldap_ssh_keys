class ldap_ssh_keys::params {

    # OS specific params
    case $::osfamily {
        'Debian': {
            $ldap_util_package = 'ldap-utils'
            $ldap_config_file  = '/etc/ldap/ldap.conf'
            $ssh_lookup_shell  = '/usr/sbin/nologin'
        }
        'RedHat': {
            $ldap_util_package = 'openldap-clients'
            $ldap_config_file  = '/etc/openldap/ldap.conf'
            $ssh_lookup_shell  = '/sbin/nologin'
        }
        default: {
            fail("ldap_ssh_keys - Unsupported Operating System family: ${::osfamily}")
        }
    }

    # OS independant params
    $key_wrapper_template = 'ldap_ssh_keys/ssh-ldap-wrapper.erb'
    $key_wrapper_file     = '/usr/local/bin/ssh-ldap-wrapper'
    $ldap_config_template = 'ldap_ssh_keys/ldap.conf.erb'
    $create_ldap_config   = false
    $ldap_servers         = ['ldap://example0.company.com/', 'ldap://example1.company.com']
    $ldap_base            = 'dc=company,dc=com'
    $ldap_bind_user       = 'company_service_unix_ldap'
    $ldap_bind_pass       = 'company_authtok'
    $ldap_ca_cert         = '/etc/ssl/certs/company-cacert.pem'
    $ldap_req_cert        = 'demand'
    $create_lookup_user   = false
    $ssh_lookup_user      = 'ssh-key-lookup'
    $ldap_starttls        = true

}
