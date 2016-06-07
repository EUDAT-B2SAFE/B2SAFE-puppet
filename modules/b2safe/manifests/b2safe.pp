  # == Class: b2safe::b2safe
  #
  # == Description ==
  #
  # This class should provide the deployment of b2safe. It will download the source from Github, build a package and
  # install it.
  #
  # === Parameters
  #
  # [*base_uri*]
  #   This is the URI to the PID Handle service. Mandatory to be set.
  #
  # [*username*]
  #   Username at the PID Handle service. Mandatory to be set.
  #
  # [*prefix*]
  #   Prefix for the PID Handle service. Mandatory to be set.
  #
  # [*users*]
  #   A list of users at the different zones. E.g user1#zone1. Mandatory to be set.
  #
  # [*b2safe_version*]
  #   B2SAFE Version that will be installed. Default is 3.0.2.
  #
  # [*run_scripts*]
  #   Decide if setup scripts from iRODS and B2SAFE should run after package installation. Default is true.
  #
  # === Authors
  #
  #
  #
  # === Copyright
  #
  # Copyright 2015 EUDAT2020
  #

  class b2safe::b2safe(
  $base_uri    = undef,
  $username    = undef,
  $prefix      = undef,
  $user        = undef,
  $b2safe_version = '3.0.2',
  ){

  $b2safe_package_version = regsubst($b2safe_version,'^(\d+)\.(\d+)\.(\d+)$','\1.\2-\3')
  
  package{'rpm-build':
    ensure   => 'installed',
    provider => 'yum'
  } ->

  file{'/etc/rpm/macros':
    ensure  => 'present',
    content => '%_topdir /home/irods/rpmbuild',
    mode    => '0644'
  }

  #Clone b2safe version 3.0.2 (work around) 
  exec{'get_B2SAFE_rpm':
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    command => 'git clone https://github.com/EUDAT-B2SAFE/B2SAFE-core /home/irods/B2SAFE-core && cd /home/irods/B2SAFE-core && git reset --hard 6e30b3c32051710e2630aa7255739f28828940f8',
    creates => '/home/irods/B2SAFE-core',
    user    => 'irods'
  } ->

  exec{'create_rpm':
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd     => '/home/irods/B2SAFE-core/packaging',
    command => 'sh create_rpm_package.sh',
    user    => 'irods'
  } ->

  #=======================================================
  # Install package and update configuration file 
  #======================================================

  exec{'install_rpm':
    unless  => 'rpm -qa |grep irods-eudat-b2safe',
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    command => 'rpm -ivh /home/irods/rpmbuild/RPMS/noarch/irods-eudat-b2safe-3.0-2.noarch.rpm',
  } ->

  file { '/opt/eudat/b2safe/packaging/install.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('b2safe/install.erb'),
  }
}
