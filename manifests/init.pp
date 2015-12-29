class ldap_ssh_keys (
    $ldap_util_package    = $ldap_ssh_keys::params::ldap_util_package,
    $ldap_config_file     = $ldap_ssh_keys::params::ldap_config_file,
    $ldap_config_template = $ldap_ssh_keys::params::ldap_config_template,
    $key_wrapper_template = $ldap_ssh_keys::params::key_wrapper_template,
    $key_wrapper_file     = $ldap_ssh_keys::params::key_wrapper_file,
    $create_ldap_config   = $ldap_ssh_keys::params::create_ldap_config,
    $ldap_servers         = $ldap_ssh_keys::params::ldap_servers,
    $ldap_base            = $ldap_ssh_keys::params::ldap_base,
    $ldap_bind_user       = $ldap_ssh_keys::params::ldap_bind_user,
    $ldap_bind_pass       = $ldap_ssh_keys::params::ldap_bind_pass,
    $ldap_ca_cert         = $ldap_ssh_keys::params::ldap_ca_cert,
    $ldap_req_cert        = $ldap_ssh_keys::params::ldap_req_cert,
    $create_lookup_user   = $ldap_ssh_keys::params::create_lookup_user,
    $ssh_lookup_user      = $ldap_ssh_keys::params::ssh_lookup_user,
    $ssh_lookup_shell     = $ldap_ssh_keys::params::ssh_lookup_shell,
    ) inherits ldap_ssh_keys::params {

    # Ensure the package containing ldapsearch is installed
    package { $ldap_util_package:
        ensure => installed,
    }

    # Create the SSH key retrieval script
    file { $key_wrapper_file:
        content => template($key_wrapper_template),
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    # If we are managing the ldap.conf file generate it
    if (str2bool($create_ldap_config)) {
        file { $ldap_config_file:
            content => template($ldap_config_template),
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
        }
    }

    # If we are managing the lookup user create it
    if (str2bool($create_lookup_user)) {
        user { $ssh_lookup_user:
            ensure  => present,
            name    => $ssh_lookup_user,
            comment => 'SSH KEY Lookup User',
            shell   => $ssh_lookup_shell,
            home    => '/dev/null',
            system  => true,
        }
    }

}
