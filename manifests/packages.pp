## Class repos 
# setup source files for required repositories depending on operation system

class puppet-b2safe::packages(
  $os
){
  notify{ "Operating system ${os}": }
  case $os{
    'sl6.6': {
      notify{ "Repos for ${os}": }

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


      ensure_packages(['fuse-libs','perl','perl-JSON','python-jsonschema','python-psutil','python-requests','authd'])

      package { 'irods-icat-4.1.5':
        provider => rpm,
        ensure   => installed,
        source   => "ftp://ftp.renci.org/pub/irods/releases/4.1.5/centos6/irods-icat-4.1.5-centos6-x86_64.rpm",
        require  =>Package['fuse-libs','perl','perl-JSON','python-jsonschema','python-psutil','python-requests']
      }

    }
    'CentOS7': {
      notify{ "Repos for ${os}": }

      package { 'epel-release-7-5':
        provider => rpm,
        ensure   => installed,
        source   => "http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm",
      }->

      package { 'pgdg-centos93-9.3-2':
        provider => rpm,
        ensure   => installed,
        source   => "http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-2.noarch.rpm",
      }->

      class { 'install_packages': }->


      package { 'irods-icat-4.1.6':
        provider => rpm,
        ensure   => installed,
        source   => "ftp://ftp.renci.org/pub/irods/releases/4.1.6/centos7/irods-icat-4.1.6-centos7-x86_64.rpm",
        require  =>Package['fuse-libs','perl','perl-JSON','python-jsonschema','python-psutil','python-requests']
      }
    }

    'Scientific7': {
      notify{ "Repos for ${os}": }

      package { 'epel-release-7-5':
        provider => rpm,
        ensure   => installed,
        source   => "http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm",
      }->

      package { 'pgdg-sl93-9.3-2':
        provider => rpm,
        ensure   => installed,
        source   => "http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-sl93-9.3-2.noarch.rpm",
      }->

      class { 'install_packages': }->


      package { 'irods-icat-4.1.7':
        provider => rpm,
        ensure   => installed,
        source   => "ftp://ftp.renci.org/pub/irods/releases/4.1.7/centos7/irods-icat-4.1.7-centos7-x86_64.rpm",
        require  =>Package['fuse-libs','perl','perl-JSON','python-jsonschema','python-psutil','python-requests']
      }
    }



    default: {
      notify{ "in default: nothing to do": }
    }
  }
}

class install_packages{
  ensure_packages(['lsof','fuse-libs','perl','perl-JSON','python-psutil','python-jsonschema','python-requests','authd'])
}


