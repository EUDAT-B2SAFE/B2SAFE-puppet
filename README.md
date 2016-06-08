# puppet-b2safe

Automatic installation for EUDAT B2SAFE service 

##Status

* Current implementation tested on Scientific Linux 6 and CentOS 7 and Scientific 7. 
* Two branches: Standalone installation & Puppet infrastructure 
* Installation and configuration of Postgresql 9.3 
* Installation of iRods4.1.8 
* Installation of B2SAFE package  3.1-1

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


## Configuration Parameters 

###Database configuration paramenters

db_user

iRODS database user, which will be used for configuration of database instance. Thish instance will be used by the iRODS by means of database plugin. 

db_password

databasehostorip

databaseport

databasename

pgdata

###iRODs configuration parameters

irods_icat_version

Version of iCAT server. Latest default is 4.1.8. An iCAT server is just a Resource server that also provides the central point of coordination for the Zone and manages the metadata. The irods-icat package installs the iRODS binaries and management scripts.

account_name

group_name

zone 

port             

rangestart

rangeend

resourcedir

localzonekey

negotiationkey

controlplaneport

controlplanekey

validationbaseuri

adminpassword


###B2SAFE configuration parameters

b2safe_version

B2SAFE Version that will be installed. Latest default is 3.1-1. 

base_uri

This is the URI to the PID Handle service. Mandatory to be set.

username        

Username at the PID Handle service. Mandatory to be set.

prefix         

Prefix for the PID Handle service. Mandatory to be set.

users 

A list of users at the different zones. E.g user1#zone1. Mandatory to be set.
 
