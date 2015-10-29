

class puppet-b2safe::postgresql(
$password='irods'
)
{

  notify {"IN POSTGRESQL":}

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


  exec{'postgresql-9.3':
   path    => '/bin:/usr/bin:/sbin:/usr/sbin',
   command => 'service postgresql-9.3 initdb && service postgresql-9.3 start'
  }

#=====================================================
#Setup ICAT DB, user access and grant priviledges 
#=====================================================

 file{'/var/lib/pgsql/9.3/data/pg_hba.conf':
  ensure => present, 
  owner  => 'postgres',
  group  => 'postgres',
  source => 'puppet:///modules/puppet-b2safe/pg_hba.conf',
  notify => Service ['postgresql-9.3']
  }->

 service{'postgresql-9.3':
  ensure  => 'running',
  require => File['/var/lib/pgsql/9.3/data/pg_hba.conf']
  }

 exec{'setup_ICAT_DB':
  unless  => "/usr/pgsql-9.3/bin/psql -U postgres --list |grep icat",
  #unless  => "/usr/pgsql-9.3/bin/psql -U postgres -lqt | cut -d \| -f 1 | grep -w icat |wc -l" 
  command => "/usr/pgsql-9.3/bin/psql -U postgres -c 'CREATE DATABASE ICAT'",
 }->

 exec{'add_user':
  unless  => "/usr/pgsql-9.3/bin/psql -U postgres -c \"SELECT 1 FROM pg_roles WHERE rolname='irods'\" |grep 1",
  command => "/usr/pgsql-9.3/bin/psql -U postgres -c \"CREATE USER irods WITH PASSWORD '${password}'\"",
 }->

exec{'grand_priv':
  command => "/usr/pgsql-9.3/bin/psql -U postgres -c \"GRANT ALL PRIVILEGES ON DATABASE ICAT TO irods\"",
 }



}

