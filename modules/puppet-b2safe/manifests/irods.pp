#Class irods is used to perform irods initial configuration

class puppet-b2safe::irods(
$account_name = 'irods',
$group_name   = 'irods',



){
 
#Create Vault directory

 file {['/data/','/data/irodsVault/']:
 ensure => 'directory',
 mode   => 775
 }

#Create irods user 

file {"/home/${account_name}":
 ensure => 'directory',
 owner  => "${account_name}",
 mode   => 700
 }

user {$account_name:
      ensure  => 'present',
      gid     => '0',
      home    => '/home/irods',
      shell   => '/bin/bash',
      uid     => '776',
    }

#Prepare configuration files 

file { '/var/lib/irods/packaging/setup_irods_service_account.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('puppet-b2safe/setup_irods_service_account.erb'),
  }

file { '/var/lib/irods/packaging/setup_irods_configuration.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('puppet-b2safe/setup_irods_configuration.erb'),
    }







}
