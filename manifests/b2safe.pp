#Class irods is used to perform irods initial configuration

class b2safe::b2safe(
  $base_uri       = undef,
  $username       = undef,
  $prefix         = undef,
  $users          = undef,
  $b2safe_version = '3.0.2',
  $run_scripts    = true
){
  $b2safe_package_version = regsubst($b2safe_version,'^(\d+)\.(\d+)\.(\d+)$','\1.\2-\3')

  case $::operatingsystem{
    'Scientific', 'CentOS': {
      package{ 'rpm-build':
        ensure   => 'installed',
      } ->

      file{ '/etc/rpm/macros':
        ensure  => 'present',
        content => "%_topdir /home/${::b2safe::irods::account_name}/rpmbuild",
        mode    => '0644'
      } ->

      exec{ 'create_rpm':
        path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
        cwd     => "/home/${::b2safe::irods::account_name}/B2SAFE-core/packaging",
        onlyif  => "test ! -e /home/${::b2safe::irods::account_name}/rpmbuild/RPMS/noarch/irods-eudat-b2safe-${b2safe_package_version}.noarch.rpm",
        command => 'sh create_rpm_package.sh',
        user    => $::b2safe::irods::account_name,
        require => Exec[ 'get_B2SAFE' ],
      } ->

        #=======================================================
        # Install package and update configuration file
        #======================================================

      exec{ 'install_rpm':
        unless  => 'rpm -qa |grep irods-eudat-b2safe',
        path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
        command => "rpm -ivh /home/${::b2safe::irods::account_name}/rpmbuild/RPMS/noarch/irods-eudat-b2safe-${b2safe_package_version}.noarch.rpm",
      } ->

      file { '/opt/eudat/b2safe/packaging/install.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template('b2safe/install.erb'),
      }
    }
    default: {}

  #Clone b2safe version 3.0.2 (work around)
  package{ 'git':
    ensure => installed,
  }

  exec{ 'get_B2SAFE':
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    command => "git clone https://github.com/EUDAT-B2SAFE/B2SAFE-core /home/${::b2safe::irods::account_name}/B2SAFE-core && cd /home/${::b2safe::irods::account_name}/B2SAFE-core && git reset --hard v${::b2safe::b2safe::b2safe_version}",
    creates => "/home/${::b2safe::irods::account_name}/B2SAFE-core",
    user    => $::b2safe::irods::account_name,
    require => Package[ 'git' ],
  }

  if $run_scripts {
    exec{ '/var/lib/irods/packaging/setup_irods.sh':
      path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
      cwd     => '/var/lib/irods/packaging',
      command => 'sh setup_irods.sh',
      user    => 'root',
    } ->

    exec{ '/opt/eudat/b2safe/packaging/install.sh':
      path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
      cwd     => '/opt/eudat/b2safe/packaging',
      command => 'sh install.sh',
      user    => $::b2safe::irods::account_name,
    }
  }


}
