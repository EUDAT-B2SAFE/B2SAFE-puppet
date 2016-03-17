# == Class db ===
#
# == Description ==
# Class for configuration of the postgressql 
#
#

  class puppet-b2safe::db(
){
$os=hiera('puppet-b2safe::packages::os')

  case $os{
  'sl6.6':      { class {'puppet-b2safe::postgresql':} }
  'CentOS7':    {class {'puppet-b2safe::postgresql':}}
  'Scientific7':{class {'puppet-b2safe::postgresql':}}
  default:      {notify {'in default: nothing to do':}}
  }
}
