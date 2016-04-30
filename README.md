# puppet-b2safe

Automatic installation for EUDAT B2SAFE service 

##Status

* Current implementation tested on Scientific Linux 6 and CentOS 7 and Scientific 7. 
* Installation and configuration of Postgresql 9.3 
* Installation of iRods4.1.7
* Installation of B2SAFE package  3.0-2

## Puppet version 
* puppet version 3.8.x

## B2SAFE deployment procedure: 
  
* Setup B2SAFE Puppet Module on the host<br>
  wget https://raw.githubusercontent.com/EUDAT-B2SAFE/B2SAFE-puppet/master/setup_module.sh<br>
  chmod +x setup_module.sh<br> 
  ./setup_module.sh 

* Apply your parameters for configuration of Postgres, iRods and B2SAFE in file:<br>
  /etc/puppet/parameters/common.yaml 

* Run puppet in masterless mode: <br>
   cd /etc/puppet/<br>
   sudo puppet apply --modulepath /etc/puppet/modules/ site.pp

* Execute iRods setup script:<br>
   sudo /var/lib/irods/packaging/setup_irods.sh

* As irods user execute B2SAFE install script: <br>
  su - irods <br>
  cd /opt/eudat/b2safe/packaging/<br>
  ./install.sh  
