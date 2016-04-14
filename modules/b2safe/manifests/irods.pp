#Class irods is used to perform irods initial configuration

class b2safe::irods(
$account_name      = 'irods',
$group_name        = 'irods',
$ZONE              = 'zone',
$PORT              = '1247',
$RANGESTART        = '20000',
$RANGEEND          = '20199',
$RESOURCEDIR       = '/data/irodsVault',
$LOCALZONEKEY      = 'TEMPORARY_zone_key',
$NEGOTIATIONKEY    = 'TEMPORARY_32byte_negotiation_key',
$CONTROLPLANEPORT  = '1248',
$CONTROLPLANEKEY   = 'TEMPORARY__32byte_ctrl_plane_key',
$VALIDATIONBASEURI = 'https://schemas.irods.org/configuration',
$ADMINPASSWORD     = 'changeme',


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
    content => template('b2safe/setup_irods_service_account.erb'),
  }

file { '/var/lib/irods/packaging/setup_irods_configuration.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('b2safe/setup_irods_configuration.erb'),
    }

}
