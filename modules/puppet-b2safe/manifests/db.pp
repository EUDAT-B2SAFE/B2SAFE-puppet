# == Class db ===
#
# == Description ==
# Class for configuration of the postgressql 
#
#

  class db(
){
$os=hiera('puppet-b2safe::packages::os')

  case $os{ 
  'sl6.6':{
  class {'puppet-b2safe::postgresql':}
  }	
 }
}
 

