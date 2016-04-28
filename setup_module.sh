#!/bin/bash

printf "This script will try: \n 1. To install puppet tool \n 2. To install git \n 3. To download B2SAFE Puppet Module from Github \n 4. To move it to the default puppet directory at /etc/puppet\n"

read -p "Are you ready to start? [y/n]" -n 1 -r

 if [[ $REPLY =~ ^[Yy]$ ]]; then
 echo " " 
 else
  echo " Exiting..." 
  exit 0
 fi

#=====================================
# Install puppet 
#=====================================

#=====================================
#Install git 
#=====================================
cmd=`yum install -y git`

if [ $? -eq 0 ]; then
 echo "" 
 echo "Git installed successfully" 
 echo "=====================================" 
else 
 echo "Git installation failed" 
 exit 1 
fi 
#=====================================
# Download puppet module from github 
#=====================================
current_dir=`pwd`
#echo "$current_dir/B2SAFE-puppet"

if [ -d "$current_dir/B2SAFE-puppet" ]; then 
 echo "The module directory $current_dir/B2SAFE-puppet already exists and will be copied to /etc/puppet."
else 
 cmd=`git clone https://github.com/EUDAT-B2SAFE/B2SAFE-puppet.git`

 if [ $? -eq 0 ]; then 
  echo "Module copied from github successfully"
  echo "======================================"  
 else 
  echo "Module download from github failed.Exiting..." 
  exit 1 
 fi 
fi 

#=====================================
#Move puppet module to /etc/puppet
#=====================================
module_dir=/etc/puppet/modules/b2safe/
puppet_dir=/etc/puppet

if [ -d $module_dir ]; then 
 echo "B2SAFE Module is already copied to /etc/puppet/. Do nothing." 
 exit 0 
elif [ -d $puppet_dir ]; then 
 echo "Puppet directory /etc/puppet exists and will be replaced."
 read -p "Do you want to delete current /etc/puppet directory and replace its content with B2SAFE puppet module?" -n 1 -r 

 if [[ $REPLY =~ ^[Yy]$ ]]; then 
 cmd=`rm -rf /etc/puppet`
 cmd=`mv B2SAFE-puppet /etc/puppet`
 echo " "
 else 
  echo "The /etc/puppet directory wasn't replaced. Exiting." 
  exit 0 
 fi 

elif [ ! -d "$puppet_dir" ]; then 
  echo "The puppet directory doesn't exist. It will be created and B2SAFE module will be copied to it."
  cmd=`mv B2SAFE-puppet /etc/puppet`
  exit 0 
fi 




