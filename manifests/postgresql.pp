class b2safe::postgresql(
  $db_password        = undef,
  $db_user            = 'irods',
  $databasehostorip   = 'localhost',
  $databaseport       = '5432',
  $databasename       = 'ICAT',
  $pgdata             = '/var/lib/pgsql/9.3/data/',
  $dependencies       = ['unixODBC', 'unixODBC-devel'],
  $manage_database    = false
)
{
  package{ $dependencies:
    ensure => installed,
  }

  case $::operatingsystem{
    'Scientific', 'CentOS': {
      case $::operatingsystemmajrelease{
        6: {
          $irods_plugin_source = "ftp://ftp.renci.org/pub/irods/releases/${::b2safe::packages::irods_icat_version}/centos6/irods-database-plugin-postgres93-${::b2safe::packages::irods_icat_min_version}-centos6-x86_64.rpm"
          $start_database_command = 'service postgresql-9.3 start'
        }
        7: {
          $irods_plugin_source = "ftp://ftp.renci.org/pub/irods/releases/${::b2safe::packages::irods_icat_version}/centos7/irods-database-plugin-postgres93-${::b2safe::packages::irods_icat_min_version}-centos7-x86_64.rpm"
          $start_database_command = 'systemctl start postgresql-9.3'
        }
        default:
        {
          notify{ 'not supported operatingsystem majerrelease': }
        }
      }
    }
    default:
    {
      notify{ 'not supported operatingsystem release': }
    }
  }

  package{ 'postgresql93-server':
    ensure  => installed,
    require => Package[ $dependencies ],
  } ->

  package{ 'postgresql93-odbc':
    ensure  => installed,
    require => Package[ $dependencies ],
  } ->

  package { 'irods-database-plugin-postgres93':
    ensure   => installed,
    provider => rpm,
    source   => $irods_plugin_source,
    require  => Package[ "irods-icat-${::b2safe::packages::irods_icat_version}" ]
  } ->

  file { '/usr/lib/systemd/system/postgresql-9.3.service':
    ensure => present,
    notify => Exec[ 'Change PGDATA Path' ],
  } ->
  exec { 'Change PGDATA Path':
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => "sed -i \"s@Environment=PGDATA=.*@Environment=PGDATA=${pgdata}@g\" /usr/lib/systemd/system/postgresql-9.3.service",
    refreshonly => true,
  }

  if $manage_database {
    exec{ 'initdb':
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      creates => "${pgdata}/postgresql.conf",
      command => '/usr/pgsql-9.3/bin/postgresql93-setup initdb'
    } ->

    exec{ 'postgresql-9.3':
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      command => $start_database_command,
      require => Exec['initdb']
    } ->

    file{ "${pgdata}/pg_hba.conf":
      ensure => present,
      owner  => 'postgres',
      group  => 'postgres',
      source => 'puppet:///modules/b2safe/pg_hba.conf',
    } ->

    service{ 'postgresql-9.3':
      ensure    => 'running',
      subscribe => File["${pgdata}/pg_hba.conf"]
    } ->

    exec{ 'setup_ICAT_DB':
      unless  => '/usr/pgsql-9.3/bin/psql -U postgres --list |grep ICAT',
      #unless  => "/usr/pgsql-9.3/bin/psql -U postgres -lqt | cut -d \| -f 1 | grep -w icat |wc -l"
      command => "/usr/pgsql-9.3/bin/psql -U postgres -c 'CREATE DATABASE \"ICAT\"'",
    } ->

    exec{ 'add_user':
      unless  => "/usr/pgsql-9.3/bin/psql -U postgres -c \"SELECT 1 FROM pg_roles WHERE rolname='${db_user}'\" |grep 1",
      command => "/usr/pgsql-9.3/bin/psql -U postgres -c \"CREATE USER ${db_user} WITH PASSWORD '${db_password}'\"",
    } ->

    exec{ 'grand_priv':
      command => "/usr/pgsql-9.3/bin/psql -U postgres -c 'GRANT ALL PRIVILEGES ON DATABASE \"ICAT\" TO ${db_user}\'",
    }
  }
    #======================================================
    # Copy configuration file for the Database
    #======================================================

  file { '/var/lib/irods/packaging/setup_irods_database.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('b2safe/setup_irods_database.erb'),
  }
}
