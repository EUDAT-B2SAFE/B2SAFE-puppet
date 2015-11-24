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
* Currently the puppet 3.8.x should be installed: 
** rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
** yum install puppet-3.8.2
* Download repository in e.g. /home/ 
* Replace completely /etc/puppet with downloaded repository <br>
   rm -rf /etc/puppet 
   mv puppet-b2safe /etc/puppet
* Apply your parameters for for configuration of Postgres, iRods and B2SAFE in file 
  /etc/puppet/parameters/common.yaml 
* Run puppet in masterless mode: <br>
   cd /etc/puppet/
   puppet apply --modulepath /etc/puppet/modules/ site.pp
* Execute iRods setup script: 
  /var/lib/irods/packaging/setup_irods.sh
* Executre B2SAFE install script: 
  cd /opt/eudat/b2safe/packaging/
  ./install.sh  
 
