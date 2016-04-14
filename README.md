# puppet-b2safe

Automatic installation for EUDAT B2SAFE service 

##Status

* Current implementation tested on Scientific Linux 6.6 and CentOS 7.2 and Scientific 7.1 
* Installation and configuration of Postgresql 9.3 
* Installation of iRods4.1.6 for SL6 and CentOS 7 and iRods 4.1.7 for Scienfic Linux 
* Installation of B2SAFE package  3.0-2

## Puppet version 
* puppet version 3.8.x

## Usage steps: 
* Currently the puppet 3.8.x should be installed:<br> 
  * For SL6:<br> 
  sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm <br>
  * For CentOS7:<br> 
  sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm <br>

  sudo yum install puppet-3.8.2
  
* Setup B2SAFE Puppet Module on the host<br>
  wget https://raw.githubusercontent.com/EUDAT-B2SAFE/B2SAFE-puppet/master/setup_module.sh
  chmod +x setup_module.sh 
  ./setup_module.sh 

* Choose between SL6.6 or CentOS7 or Scientific7 and apply your parameters for configuration of Postgres, iRods and B2SAFE in file:<br>
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
