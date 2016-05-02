  # == Class: packages
  #
  # setup source files for required repositories depending on operation system
  #
  # === Parameters
  #
  # [*sample_parameter*]
  #
  #
  # === Authors
  #
  #
  # === Copyright
  #
  # Copyright 2015 EUDAT2020
  #

  class b2safe::packages(
    $irods_icat_version = '4.1.7',
    $dependencies = ['fuse-libs', 'perl', 'perl-JSON', 'python-jsonschema', 'python-psutil', 'python-requests', 'authd', 'lsof']
  ){

  $irods_icat_min_version = regsubst($irods_icat_version,'^(\d+)\.(\d+)\.(\d+)$','\2.\3')

  package {'yum-utils':
    ensure => 'present'
  }

  case $::operatingsystem{
    'Scientific':{
      notify{"Repos for ${::operatingsytem}":}
      case $::operatingsystemmajrelease {
        6: {
          package { 'epel-release-6-8':
            ensure   => installed,
            provider => rpm,
            source   => 'http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm',
          }

          package { $dependencies:
            ensure  => installed,
            require => Package ['epel-release-6-8']
          }
          
          package { 'pgdg-sl93-9.3-2':
            ensure   => installed,
            provider => rpm,
            source   => 'http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-sl93-9.3-2.noarch.rpm',
          }

          package { "irods-icat-${irods_icat_version}":
            ensure   => installed,
            provider => rpm,
            source   => "ftp://ftp.renci.org/pub/irods/releases/${irods_icat_version}/centos6/irods-icat-${irods_icat_version}-centos6-x86_64.rpm",
            require  => Package[$dependencies]
          }
        }
        7: {
          package { 'epel-release-7-6':
              ensure   => installed,
              provider => rpm,
              source   => 'http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm',
          }
      
          package { $dependencies:
            ensure  => installed,
            require => Package ['epel-release-7-6']
          }

          package { 'pgdg-sl93-9.3-2':
            ensure   => installed,
            provider => rpm,
            source   => 'http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-sl93-9.3-2.noarch.rpm',
          }->
          
          package { "irods-icat-${irods_icat_version}":
            ensure   => installed,
            provider => rpm,
            source   => "ftp://ftp.renci.org/pub/irods/releases/${irods_icat_version}/centos7/irods-icat-${irods_icat_version}-centos7-x86_64.rpm",
            require  =>Package[$dependencies]
          }
        }
        default:
          {
            notify{ 'not supported operatingsystem majorrelease': }
          }
      }
    }
    'CentOS':{
      case $::operatingsystemmajrelease {
        7: {
          package { 'epel-release-7-6':
            ensure   => installed,
            provider => rpm,
            source   => 'http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm',
          }

          package { $dependencies:
            ensure  => installed,
            require => Package ['epel-release-7-6']
          }
          
          package { 'pgdg-centos93-9.3-2':
            ensure   => installed,
            provider => rpm,
            source   => 'http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-2.noarch.rpm',
          }->
        
          
          package { "irods-icat-${irods_icat_version}":
            ensure   => installed,
            provider => rpm,
            source   => "ftp://ftp.renci.org/pub/irods/releases/${irods_icat_version}/centos7/irods-icat-${irods_icat_version}-centos7-x86_64.rpm",
            require  =>Package[$dependencies]
          }
        }

        default:
          {
            notify{'in default: nothing to do':}
          }
    }
    }
    default: {
      notify{ 'in default: nothing to do': }
    }
  }
  }



