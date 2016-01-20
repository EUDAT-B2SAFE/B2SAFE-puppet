# puppet-b2safe

Automatic installation for EUDAT B2SAFE service 

##Status

* Current implementation tested on Scientific Linux 6.6 and CentOS 7.2  
* Installation and configuration of Postgresql 9.3 
* Installation of iRods4.1.5
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
  
* Install git:<br>
  sudo yum install git

* Download repository in e.g. /home/:<br>
  sudo git clone https://github.com/EUDAT-B2SAFE/B2SAFE-puppet.git

* Replace completely /etc/puppet with downloaded repository <br>
   sudo rm -rf /etc/puppet <br>
   sudo mv B2SAFE-puppet /etc/puppet

* Choose between SL6.6 or CentOS7 and apply your parameters for configuration of Postgres, iRods and B2SAFE in file:<br>
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
