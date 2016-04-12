# == Class db ===
#
# == Description ==
# Class for configuration of the postgressql 
#
#

class b2safe::db(
){
  case $::operatingsystem{
    'CentOS', 'Scientific': {
      class { '::b2safe::postgresql': }
    }
    default: { notify { 'in default: nothing to do': } }
  }
}
