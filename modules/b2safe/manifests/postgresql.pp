  # == Class: b2safe::postgresql 
  #
  # == Description ==
  #
  # This class installs and configures  a postresql for irods. 
  #
  # === Parameters
  #
  # [*base_uri*]
  #
  # === Authors
  #
  # === Copyright
  #
  # Copyright 2015 EUDAT2020

  class b2safe::postgresql(
    $db_password       =  undef,
    $db_user           = 'irods',
    $databasehostorip  = 'localhost',
    $databaseport      = '5432',
    $databasename      = 'ICAT',
    $pgdata            = "var/lib/pgsql/9.3/data/",

  )
  {
    notify {"IN POSTGRESQL":}
    case ::$operatingsystem {
      'Scientific':{
        case $::operatingsystemmajrelease{
         6: {
              class{'install_postgres_packages_sl66':} ->
              class{'setup_icat_db':}
            }
         default: {
           notify{ 'not supported operatingsystem majerrelease': }
         }
        }
      }
'CentOS':{
class{"install_postgres_packages_centos7":
     pgdata=>$PGDATA
     } ->

class{'setup_icat_db':
    pgdata=>$PGDATA
    }
   }

'Scientific7':{
class{"install_postgres_packages_scientific7":
     pgdata=>$PGDATA
     } ->

class{'setup_icat_db':
    pgdata=>$PGDATA
    }
   }
 }
}


class install_postgres_packages_sl66{

#======================================================
#Install all required postgresql
#======================================================
 ensure_packages(['authd','unixODBC','unixODBC-devel'])

 package{'postgresql93-server':
  ensure  => installed,
  require => Package ['authd','unixODBC','unixODBC-devel'],
  provider => 'yum',
  }->

package{'postgresql93-odbc':
  ensure  => installed,
  require => Package ['authd','unixODBC','unixODBC-devel'],
  provider => 'yum',
  }->

package { 'irods-database-plugin-postgres93':
    provider => rpm,
    ensure   => installed,
    source   => "ftp://ftp.renci.org/pub/irods/releases/4.1.5/centos6/irods-database-plugin-postgres93-1.6-centos6-x86_64.rpm",
    require  =>Package['irods-icat-4.1.5']
   }  ->

  exec{'initdb':
   path    => '/bin:/usr/bin:/sbin:/usr/sbin',
   unless  => 'test -d /var/lib/pgsql/9.3/data',
   command => 'service postgresql-9.3 initdb'
  } ->

exec{'postgresql-9.3':
   path    => '/bin:/usr/bin:/sbin:/usr/sbin',
   command => 'service postgresql-9.3 start',
   require => Exec['initdb']
  }
}


class install_postgres_packages_centos7($pgdata){

#======================================================
#Install all required postgresql
#======================================================
 ensure_packages(['authd','unixODBC','unixODBC-devel'])

 package{'postgresql93-server':
  ensure  => installed,
  require => Package ['authd','unixODBC','unixODBC-devel'],
  provider => 'yum',
  } ->

 package{'postgresql93-odbc':
  ensure  => installed,
  require => Package ['authd','unixODBC','unixODBC-devel'],
  provider => 'yum',
  } ->

 package { 'irods-database-plugin-postgres93':
  provider => rpm,
  ensure   => installed,
  source   => "ftp://ftp.renci.org/pub/irods/releases/4.1.6/centos7/irods-database-plugin-postgres93-1.6-centos7-x86_64.rpm",
  require  =>Package['irods-icat-4.1.6']
  } ->

 file {'/usr/lib/systemd/system/postgresql-9.3.service':
  ensure => present, 
  } -> 
 exec { 'Change PGDATA Path':
  path  => '/bin:/usr/bin:/sbin:/usr/sbin',
  command => "sed -i \"s@Environment=PGDATA=.*@Environment=PGDATA=${pgdata}@g\" /usr/lib/systemd/system/postgresql-9.3.service"
  } ->


  exec{'initdb':
   path    => '/bin:/usr/bin:/sbin:/usr/sbin',
   creates => "${pgdata}/postgresql.conf",
   command => '/usr/pgsql-9.3/bin/postgresql93-setup initdb'
  } ->

exec{'postgresql-9.3':
   path    => '/bin:/usr/bin:/sbin:/usr/sbin',
   command => 'systemctl start postgresql-9.3',
   require => Exec['initdb']
  }
}


class install_postgres_packages_scientific7($pgdata){


#======================================================
#Install all required postgresql
#======================================================
 ensure_packages(['authd','unixODBC','unixODBC-devel'])

 package{'postgresql93-server':
  ensure  => installed,
  require => Package ['authd','unixODBC','unixODBC-devel'],
  provider => 'yum',
  } ->

 package{'postgresql93-odbc':
  ensure  => installed,
  require => Package ['authd','unixODBC','unixODBC-devel'],
  provider => 'yum',
  } ->

 package { 'irods-database-plugin-postgres93':
  provider => rpm,
  ensure   => installed,
  source   => "ftp://ftp.renci.org/pub/irods/releases/4.1.7/centos7/irods-database-plugin-postgres93-1.7-centos7-x86_64.rpm",
  require  =>Package['irods-icat-4.1.7']
  } ->

 file {'/usr/lib/systemd/system/postgresql-9.3.service':
  ensure => present,
  } ->
 exec { 'Change PGDATA Path':
  path  => '/bin:/usr/bin:/sbin:/usr/sbin',
  command => "sed -i \"s@Environment=PGDATA=.*@Environment=PGDATA=${pgdata}@g\" /usr/lib/systemd/system/postgresql-9.3.service"
  } ->

 exec{'initdb':
   path    => '/bin:/usr/bin:/sbin:/usr/sbin',
   creates => "${pgdata}/postgresql.conf",
   command => '/usr/pgsql-9.3/bin/postgresql93-setup initdb'
  } ->

exec{'postgresql-9.3':
   path    => '/bin:/usr/bin:/sbin:/usr/sbin',
   command => 'systemctl start postgresql-9.3',
   require => Exec['initdb']
  }
}

class setup_icat_db(
$db_password       ='irods',
$db_user           ='irods',
$pgdata
)
{
#=====================================================
#Setup ICAT DB, user access and grant priviledges 
#=====================================================

 file{"${pgdata}/pg_hba.conf":
  ensure => present,
  owner  => 'postgres',
  group  => 'postgres',
  source => 'puppet:///modules/b2safe/pg_hba.conf',
  }->


 service{'postgresql-9.3':
  ensure  => 'running',
  subscribe => File["${pgdata}/pg_hba.conf"]
  }->

 exec{'setup_ICAT_DB':
  unless  => "/usr/pgsql-9.3/bin/psql -U postgres --list |grep ICAT",
  #unless  => "/usr/pgsql-9.3/bin/psql -U postgres -lqt | cut -d \| -f 1 | grep -w icat |wc -l" 
  command => "/usr/pgsql-9.3/bin/psql -U postgres -c 'CREATE DATABASE \"ICAT\"'",
 }->

 exec{'add_user':
  unless  => "/usr/pgsql-9.3/bin/psql -U postgres -c \"SELECT 1 FROM pg_roles WHERE rolname='${db_user}'\" |grep 1",
  command => "/usr/pgsql-9.3/bin/psql -U postgres -c \"CREATE USER ${db_user} WITH PASSWORD '${db_password}'\"",
 }->

exec{'grand_priv':
  command => "/usr/pgsql-9.3/bin/psql -U postgres -c 'GRANT ALL PRIVILEGES ON DATABASE \"ICAT\" TO ${db_user}\'",
 }->
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


