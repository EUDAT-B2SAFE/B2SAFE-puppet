# == Class: b2safe::packages
#
# == Description ==
#
# This class manage the installation of necessary packages depending on operation system.
# install it.
#
# === Parameters
#
# [*install_epel*]
#   Decide if epel for RHEL like operationg systems should be installed.
#
# [*dependencies*]
#   A list of dependencies, needed by iRODS and Postgresql.
#
# [*python_dependencies*]
#   A list of python dependencies, needed by B2SAFE.
#
#[*pip_dependencies*]
#   A list of python dependencies from pip, needed by B2SAFE.
#
# [*irods_icat_version*]
#   iCAT version. Default is 4.1.7.
#
# === Authors
#
#
#
# === Copyright
#
# Copyright 2015 EUDAT2020
#

class b2safe::packages(
  $install_epel = true,
  $dependencies = ['fuse-libs', 'perl', 'perl-JSON', 'python-jsonschema', 'python-psutil', 'python-requests', 'authd', 'lsof'],
  $python_dependencies = ['python-pip', 'python-simplejson', 'python-httplib2', 'python-defusedxml', 'python-lxml'],
  $pip_dependencies = ['queuelib', 'dweepy'],
  $irods_icat_version = '4.1.7'
){
  validate_bool($install_epel)
  validate_array($dependencies)
  validate_array($python_dependencies)
  validate_array($pip_dependencies)
  validate_string($irods_icat_version)

  $irods_icat_min_version = regsubst($irods_icat_version,'^(\d+)\.(\d+)\.(\d+)$','\2.\3')

  package { $dependencies:
    ensure  => installed,
  }

  package { $python_dependencies:
    ensure  => installed,
  }

  file { '/usr/bin/pip-python':
    ensure => 'link',
    target => '/usr/bin/pip',
  }

  package { $pip_dependencies:
    ensure   => installed,
    provider => pip,
    require  => [ Package[ $python_dependencies ], File[ '/usr/bin/pip-python' ] ],
  }

  case $::operatingsystem{
    'Scientific': {
      case $::operatingsystemmajrelease {
        6: {
          if $install_epel{
            package { 'epel-release-6-8':
              ensure   => installed,
              provider => rpm,
              source   => 'http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm',
            }
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
          if $install_epel{
            package { 'epel-release-7-6':
              ensure   => installed,
              provider => rpm,
              source   => 'http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm',
            }
          }

          package { 'pgdg-sl93-9.3-2':
            ensure   => installed,
            provider => rpm,
            source   => 'http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-sl93-9.3-2.noarch.rpm',
          }

          package { "irods-icat-${irods_icat_version}":
            ensure   => installed,
            provider => rpm,
            source   => "ftp://ftp.renci.org/pub/irods/releases/${irods_icat_version}/centos7/irods-icat-${irods_icat_version}-centos7-x86_64.rpm",
            require  => Package[$dependencies]
          }
        }
        default:
        {
          notify{ 'not supported operatingsystem majorrelease': }
        }
      }
    }
    'CentOS': {
      case $::operatingsystemmajrelease {
        7: {
          if $install_epel{
            package { 'epel-release-7-6':
              ensure   => installed,
              provider => rpm,
              source   => 'http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm',
            }
          }

          package { 'pgdg-centos93-9.3-2':
            ensure   => installed,
            provider => rpm,
            source   => 'http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-2.noarch.rpm',
          }

          package { "irods-icat-${irods_icat_version}":
            ensure   => installed,
            provider => rpm,
            source   => "ftp://ftp.renci.org/pub/irods/releases/${irods_icat_version}/centos7/irods-icat-${irods_icat_version}-centos7-x86_64.rpm",
            require  => Package[$dependencies]
          }
        }
        default:
        {
          notify{ 'not supported operatingsystem majorrelease': }
        }
      }
    }
    default: {
      notify{ 'in default: nothing to do': }
    }
  }

}
