# puppet-b2safe

Automatic installation for EUDAT B2SAFE service 

##Status

* Current implementation tested on Scientific Linux 6 
* Installation of iRods4.1.5 
* Installation and configuration of Postgresql 9.3 

## Puppet version 
* puppet version 3.8.x

## Usage 

* Download repository 
* Apply parameters for Postgresql or use default 
* Run puppet in masterless mode: <br>
  puppet apply --modulepath /etc/puppet/modules/ site.pp

