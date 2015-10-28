## Class repos 
# setup source files for required repositories depending on operation system

class puppet-b2safe::packages(
$os
){

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

  ensure_packages(['postgresql93-server.x86_64','postgresql93-odbc','authd','unixODBC','unixODBC-devel'])
  }

  #yumrepo {"epel": 
  # descr          => 'Extra Packages for Enterprise Linux 6 - x86_64',
  # mirrorlist     => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
  # failovermethod => 'priority'
  # enabled        => 1,    
  # gpgcheck       => 0,
  # } 
  #}

 default: {
 notify{"AAAAA":}
 }	
}
}
