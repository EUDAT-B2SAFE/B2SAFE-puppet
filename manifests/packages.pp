## Class repos 
# setup source files for required repositories depending on operation system

class b2safe::packages(
  $install_epel = true,
  $dependencies = ['fuse-libs', 'perl', 'perl-JSON', 'python-jsonschema', 'python-psutil', 'python-requests', 'authd', 'lsof'],
  $irods_icat_version = '4.1.7'
){
  notify{ "Operating system ${::operatingsystem}": }

  package { $dependencies:
    ensure  => installed,
  }

  case $::operatingsystem{
    'Scientific': {
      notify{ "Repos for ${::operatingsystem} ${::operatingsystemrelease}": }
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
            package { 'epel-release-7-5':
              ensure   => installed,
              provider => rpm,
              source   => 'http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm',
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
            package { 'epel-release-7-5':
              ensure   => installed,
              provider => rpm,
              source   => 'http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm',
            }
          }

          package { 'pgdg-sl93-9.3-2':
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
