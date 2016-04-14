#!/bin/bash

#=====================================
# Install puppet 
#=====================================

#=====================================
#Install git 
#=====================================
cmd=`yum install git`

if [$? -eq 0]; then 
 echo "Git installed successfully" 
else 
 echo "Git installation failed" 
 exit 1 
fi 
#=====================================
# Download puppet module from github 
#=====================================
cmd=`git clone https://github.com/EUDAT-B2SAFE/B2SAFE-puppet.git`

if [$? -eq 0]; then 
 echo "Module copied from github successfully" 
else 
 echo "Module download from github failed" 
 exit 1 
fi 


#=====================================
#Move puppet module to /etc/puppet
#=====================================

cmd=`rm -rf /etc/puppet`
cmd=`mv B2SAFE-puppet /etc/puppet`


