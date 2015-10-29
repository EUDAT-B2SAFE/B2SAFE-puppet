# == Class db ===
#
# == Description ==
# Class for configuration of the postgressql 
#
#

  class db(
$os,
$postgres,
){

  case $os{ 
  'sl6.6':{
  class {'puppet-b2safe::postgresql':}
  }	
 }
}
 

