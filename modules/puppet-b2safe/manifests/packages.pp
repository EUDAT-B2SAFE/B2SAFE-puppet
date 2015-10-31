## Class repos 
# setup source files for required repositories depending on operation system

class puppet-b2safe::packages(
$os
){
notify{"Operating system ${os}":}
case $os{ 
 'sl6.6':{
  notify{"Repos for ${os}":}
   
  package { 'epel-release-6-8':
    provider => rpm,
    ensure   => installed,
    source   => "http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm",
   }  
  
  package { 'pgdg-sl93-9.3-2':
    provider => rpm,
    ensure   => installed,
    source   => "http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-sl93-9.3-2.noarch.rpm",
   }   


 ensure_packages(['fuse-libs','perl','perl-JSON','python-jsonschema','python-psutil','python-requests'])

  package { 'irods-icat-4.1.5':
    provider => rpm,
    ensure   => installed,
    source   => "ftp://ftp.renci.org/pub/irods/releases/4.1.5/centos6/irods-icat-4.1.5-centos6-x86_64.rpm",
    require  =>Package['fuse-libs','perl','perl-JSON','python-jsonschema','python-psutil','python-requests']
   }
 
 package { 'irods-database-plugin-postgres93':
    provider => rpm,
    ensure   => installed,
    source   => "ftp://ftp.renci.org/pub/irods/releases/4.1.5/centos6/irods-database-plugin-postgres93-1.6-centos6-x86_64.rpm",
    require  =>Package['irods-icat-4.1.5']
   }  
  }

 default: {
 notify{"in default: nothing to do":}
 }	
}
}
