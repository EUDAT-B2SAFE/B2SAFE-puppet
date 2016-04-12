## Class repos 
# setup source files for required repositories depending on operation system

class b2safe::packages(
  $install_epel = true,
  $dependencies = ['fuse-libs','perl','perl-JSON','python-jsonschema','python-psutil','python-requests','authd']
){
  notify{ "Operating system ${::operatingsystem}": }

  package { $::b2safe::packages::dependencies:
    ensure  => installed,
  }

  case $::operatingsystem{
    'Scientific': {
      notify{ "Repos for ${::operatingsystem} ${::operatingsystemrelease}": }
      case $::operatingsystemrelease {
        6.6: {
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

          package { 'irods-icat-4.1.5':
            ensure   => installed,
            provider => rpm,
            source   => 'ftp://ftp.renci.org/pub/irods/releases/4.1.5/centos6/irods-icat-4.1.5-centos6-x86_64.rpm',
            require  => Package[$dependencies]
          }
        }
        7.0, 7.1: {
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

          package { 'irods-icat-4.1.7':
            ensure   => installed,
            provider => rpm,
            source   => 'ftp://ftp.renci.org/pub/irods/releases/4.1.7/centos7/irods-icat-4.1.7-centos7-x86_64.rpm',
            require  => Package[$dependencies]
          }
        }
        default:
        {
          notify{ 'not supported operatingsystem release': }
        }
      }
    }
    'CentOS': {
      notify{ "Repos for ${::operatingsystem}": }

      if $install_epel{
        package { 'epel-release-7-5':
          ensure   => installed,
          provider => rpm,
          source   => 'http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm',
        }
      }

      package { 'pgdg-centos93-9.3-2':
        ensure   => installed,
        provider => rpm,
        source   => 'http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-2.noarch.rpm',
      }

      package { 'irods-icat-4.1.6':
        ensure   => installed,
        provider => rpm,
        source   => 'ftp://ftp.renci.org/pub/irods/releases/4.1.6/centos7/irods-icat-4.1.6-centos7-x86_64.rpm',
        require  => Package[$dependencies]
      }
    }
    default: {
      notify{ 'in default: nothing to do': }
    }
  }

}
