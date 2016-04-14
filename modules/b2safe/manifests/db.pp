# == Class db ===
#
# == Description ==
# Class for configuration of the postgressql 
#
#

  class b2safe::db(
){
$os=hiera('b2safe::packages::os')

  case $os{
  'sl6.6':      { class {'b2safe::postgresql':} }
  'CentOS7':    {class {'b2safe::postgresql':}}
  'Scientific7':{class {'b2safe::postgresql':}}
  default:      {notify {'in default: nothing to do':}}
  }
}
