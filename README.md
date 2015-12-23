# ldap_ssh_keys Module

## Overview

The **ldap_ssh_keys** module handles the creation of a wrapper to  ssh keys from LDAP, it can also generate a ldap.conf file if required'

##Configuration

###`ldap_util_package`

The package containing LDAP tools, specifically ldapsearch **Default: ldap-utils on Debian and openldap-clients on RedHat systems**

###`ldap_config_file`

The location of the LDAP configuration file  **Default: /etc/ldap/ldap.conf on Debian and /etc/openldap/ldap.conf on RedHat systems**

###`key_wrapper_template`

The location of the template for the script that retrieves keys from LDAP **Default: ldap_ssh_keys/ssh-ldap-wrapper.erb** 

###`key_wrapper_file`

The location of the script that retrieves keys from LDAP **Default: /usr/local/bin/ssh-ldap-wrapper** 

###`ldap_config_template`

The location of the template for configuration file  **Default: ldap_ssh_keys/ldap.conf.erb** 

###`create_ldap_config`

Flag to control if we generate the LDAP configuration file **Default: empty false**

###`ldap_servers`

Array of LDAP URI's **Only used if create_ldap_config is true Default: ['ldap://example0.company.com/', 'ldap://example1.company.com']** 

###`ldap_base`

DN to use when performing ldap operations **Only used if create_ldap_config is true Default: dc=company,dc=com** 

###`ldap_bind_user`

User to use when performing ldap operations **Only used if create_ldap_config is true Default: company_service_unix_ldap** 

###`ldap_bind_pass`

Password to use when performing ldap operations **Only used if create_ldap_config is true Default: company_authtok** 

###`ldap_ca_cert`

File that contains certificates for all of the Certificate Authorities the client will recognize. **Only used if create_ldap_config is true Default: /etc/ssl/certs/company-cacert.pem**

###`ldap_req_cert`

Specifies what checks to perform on server certificates in a TLS session **Only used if create_ldap_config is true Default: demand** 

###`create_lookup_user`

Flag to control if we cratee a user to be used for ssh key lookups **Default: false**

###`ssh_lookup_user`

The username of the key lookup user **Only used if create_lookup_user is true  Default: ssh-key-lookup**

###`ssh_lookup_shell`

The shell of the key lookup user **Only used if create_lookup_user is true  Default: /usr/sbin/nologin on Debian and /sbin/nologin on RedHat systems**

##Hiera Examples:

* Global Settings

        #generate a ldap.conf file
        ldap_ssh_keys::create_ldap_config: true
        ldap_ssh_keys::ldap_req_cert: 'hard'
        ldap_ssh_keys::ldap_servers:
            - 'ldap://example0.company.com'
            - 'ldap://example1.company.com'
        ldap_ssh_keys::ldap_bind_user: 'bind_user'    
        ldap_ssh_keys::ldap_bind_pass: 'bind_password'
        #create ldap key lookup user
        ldap_ssh_keys::create_lookup_user: true
        ldap_ssh_keys::ssh_lookup_user: 'lookup-user'
        
## Dependencies

In order to make use of the retrieved SSH keys OpenSSH (>=6.2) needs to be configured with the "AuthorizedKeysCommand" and "AuthorizedKeysCommandUser" directives, this configuration needs to be performed by a OpenSSH management module.