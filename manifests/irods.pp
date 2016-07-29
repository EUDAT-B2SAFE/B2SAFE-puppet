# == Class: b2safe::irods
#
# == Description ==
#
# This class should perform the initial irods configuration.
#
# === Parameters
#
# [*account_name*]
#   Username who start iRODS. Default is irods.
#
# [*group_name*]
#   Groupname who start iRODS. Default is irods.
#
# [*zone*]
#   Name of local zone in irods. Default is zone.
#
# [*port*]
#   Port which iRODS ueses to communicate with other instances. Default is 1247.
#
# [*rangestart*]
#   First portnumber of range which iRODS uses for data exchange. Default is 20000.
#
# [*rangeend*]
#   Last portnumber of range which iRODS uses for data exchange. Default is 20199.
#
# [*resourcedir*]
#   Directory used by iRODS to store data. Default is /data/irodsVault.
#
# [*localzonekey*]
#   Key for local zone. Needed in federations to gave access to remote users. Default is TEMPORARY_zone_key.
#
# [*negotiationkey*]
#   Key for federations. This key must be the same at all iRODS instances in federation. Default is TEMPORARY_32byte_negotiation_key.
#
# [*controlplaneport*]
#   Port for iRODS control plane. Default is 1248.
#
# [*controlplanekey*]
#   Key for iRODS control plane communitcation. Default is TEMPORARY__32byte_ctrl_plane_key.
#
# [*validationbaseuri*]
#   URL to iRODS configuration schema. Default is https://schemas.irods.org/configuration.
#
# [*adminpassword*]
#   Password for admin user. Mandatory to be set.
#
# === Authors
#
#
#
# === Copyright
#
# Copyright 2015 EUDAT2020
#

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
  validate_string($account_name)
  validate_string($group_name)
  validate_string($zone)
  validate_string($port)
  validate_string($rangestart)
  validate_string($rangeend)
  validate_absolute_path($resourcedir)
  validate_string($localzonekey)
  validate_string($negotiationkey)
  validate_string($controlplaneport)
  validate_string($controlplanekey)
  validate_re($validationbaseuri,'((http|https)\:\/\/)?[A-Za-z0-9\-]*\.[A-Za-z0-9\-]+\.[A-Za-z]{2,}')
  validate_string($adminpassword)

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
