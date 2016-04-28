  # == Class: b2safe::db
  #
  # == Description ==
  #
  # This class provides interface for database choice depending on the operating system
  #
  # === Parameters
  #
  # === Authors
  #
  # === Copyright
  #
  # Copyright 2015 EUDAT2020





  class b2safe::db(
){
  case $::operatingsystem{
    'CentOS', 'Scientific': {
      class { '::b2safe::postgresql': }
    }
    default: { notify { 'in default: nothing to do': } }
  }
}
