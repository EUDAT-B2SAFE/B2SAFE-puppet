#Class irods is used to perform irods initial configuration

class b2safe::b2safe(
  $base_uri       = undef,
  $username       = undef,
  $prefix         = undef,
  $users          = undef,
  $b2safe_version = 'v3.0.2'
){

  package{ 'rpm-build':
    ensure   => 'installed',
    provider => 'yum'

  } ->

  file{ '/etc/rpm/macros':
    ensure  => 'present',
    content => "%_topdir /home/${::b2safe::irods::account_name}/rpmbuild",
    mode    => '0644'
  }

  #Clone b2safe version 3.0.2 (work around)
  exec{ 'get_B2SAFE_rpm':
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    command => "git clone https://github.com/EUDAT-B2SAFE/B2SAFE-core /home/${::b2safe::irods::account_name}/B2SAFE-core && cd /home/${::b2safe::irods::account_name}/B2SAFE-core && git reset --hard ${::b2safe::b2safe::b2safe_version}",
    creates => "/home/${::b2safe::irods::account_name}/B2SAFE-core",
    user    => $::b2safe::irods::account_name,
  } ->

  exec{ 'create_rpm':
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd     => "/home/${::b2safe::irods::account_name}/B2SAFE-core/packaging",
    command => 'sh create_rpm_package.sh',
    user    => $::b2safe::irods::account_name,
  } ->

    #=======================================================
    # Install package and update configuration file
    #======================================================

  exec{ 'install_rpm':
    unless  => 'rpm -qa |grep irods-eudat-b2safe',
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    command => "rpm -ivh /home/${::b2safe::irods::account_name}/rpmbuild/RPMS/noarch/irods-eudat-b2safe-3.0-2.noarch.rpm",
  } ->

  file { '/opt/eudat/b2safe/packaging/install.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('b2safe/install.erb'),
  }


}
