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
$os=hiera('b2safe::packages::os')

  case $os{
  'sl6.6':      { class {'b2safe::postgresql':} }
  'CentOS7':    {class {'b2safe::postgresql':}}
  'Scientific7':{class {'b2safe::postgresql':}}
  default:      {notify {'in default: nothing to do':}}
  }
}
