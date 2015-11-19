# puppet-b2safe

Automatic installation for EUDAT B2SAFE service 

##Status

* Current implementation tested on Scientific Linux 6 
* Installation and configuration of Postgresql 9.3 
* Installation of iRods4.1.5
* Installation of B2SAFE package  

## Puppet version 
* puppet version 3.8.x

## Usage 

* Download repository 
* Apply parameters for Postgresql or use default 
* Run puppet in masterless mode: <br>
  puppet apply --modulepath /etc/puppet/modules/ site.pp
* Execute iRods setup script: 
  /var/lib/irods/packaging/setup_irods.sh
* Executre B2SAFE install script: 
  /opt/eudat/b2safe/packaging/install.sh  
 
