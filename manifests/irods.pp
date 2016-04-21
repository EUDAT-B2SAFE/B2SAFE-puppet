#Class irods is used to perform irods initial configuration

class b2safe::irods(
  $account_name      = 'irods',
  $group_name        = 'irods',
  $zone              = 'zone',
  $port              = '1247',
  $rangestart        = '20000',
  $rangeend          = '20199',
  $resourcedir       = '/data/irodsVault',
  $localzonekey      = 'TEMPORARY_zone_key',
  $negotiationkey    = 'TEMPORARY_32byte_negotiation_key',
  $controlplaneport  = '1248',
  $controlplanekey   = 'TEMPORARY__32byte_ctrl_plane_key',
  $validationbaseuri = 'https://schemas.irods.org/configuration',
  $adminpassword     = undef,
){
  #Create Vault directory

  #small workaround because puppet can't create parent directories
  exec{ 'create_resource_dir':
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    onlyif  => "test ! -e ${resourcedir}",
    command => "mkdir -p ${resourcedir}",
  } ->
  file { $resourcedir:
    ensure => 'directory',
    owner  => $account_name,
    group  => $account_name,
    mode   => '0775'
  }

  #Create irods user
  user { $account_name:
    ensure     => 'present',
    home       => "/home/${account_name}",
    shell      => '/bin/bash',
    managehome => true,
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
