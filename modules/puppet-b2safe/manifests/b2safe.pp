#Class irods is used to perform irods initial configuration

class puppet-b2safe::b2safe(
$BASE_URI='',
$USERNAME='',
$PREFIX ='',
$USERS =''
){

 package{'rpm-build':
 ensure   => 'installed',
 provider => 'yum'

 } -> 

 file{'/etc/rpm/macros':
  ensure  => 'present',
  content => '%_topdir /home/irods/rpmbuild',
  mode    => '0644'
 }

 exec{'get_B2SAFE_rpm':
 path => [ '/bin', '/usr/bin', '/usr/local/bin' ],
 command => 'git clone https://github.com/EUDAT-B2SAFE/B2SAFE-core /home/irods/B2SAFE-core',
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
    content => template('puppet-b2safe/install.erb'),
  }
 

}
