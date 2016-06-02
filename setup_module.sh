#title        : setup_module.sh 
#description  : This script try to install puppet, git, download B2SAFE puppet module and put it to puppet directory 
#             : 
#author       : Pavel Weber
#date         : 23.04.2016
#version      : 0.1
#usage        : ./setup_module.sh 

#!/bin/bash
#Help message 
function usage {
      echo "Usage: $0."
}


if [[ $1 == "--help" ||  $1 == "-h" || $1 == "--h" ]]  
        then 
         usage
         exit 0
        fi


printf "This script will try: \n 1.To install puppet tool \n 2.To install git \n 3.To download B2SAFE Puppet Module from Github \n 4.To move it to the default puppet directory at /etc/puppet\n"

read -p "Start now? [y/n]" -n 1 -r

 if [[ $REPLY =~ ^[Yy]$ ]]; then
 echo " " 
 else
  echo " Exiting..." 
  exit 0
 fi

#=====================================
# Install puppet 
#=====================================

#Get the version of operating system 

#RedHat systems 
redhat_file=/etc/redhat-release

if [ -f $redhat_file ]; then 
   operating_system=$(head -n 1 $redhat_file)

else 
  echo "Operating system is not supported. Exiting..." 
  exit 0 
fi 

major_number=`echo $operating_system | sed -e 's/[^0-9]//g' | cut -c1`

if [ "$major_number" -eq 6 ]; then
  cmd=`yum clean all`
  cmd=`rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm`
  cmd=`yum -y install puppet-3.8.3`
  if [ $? -eq 0 ]; then
   echo "" 
   echo "Puppet installed successfully" 
   echo "=====================================" 
  else 
   echo "Puppet installation failed" 
   exit 1 
  fi 
elif [ "$major_number" -eq 7 ]; then
  cmd=`yum clean all`
  cmd=`rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm`
  cmd=`yum -y install puppet-3.8.3`
  if [ $? -eq 0 ]; then
   echo "" 
   echo "Puppet installed successfully" 
   echo "=====================================" 
  else
   echo "Puppet installation failed" 
   exit 1
  fi
else 
  echo "Unknown operating system major release, only 7 and 6 are supported" 
  exit 1 
fi 

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
 else 
  echo "======================================"  
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
  echo "======================================"  
  echo " " 

  printf "Next steps: \n 1.Edit /etc/puppet/parameters/common.yml \n 2.Change dir: cd /etc/puppet/ \n 3.Run command: puppet apply --modulepath /etc/puppet/modules/ site.pp\n 4.Execute iRods setup script: /var/lib/irods/packaging/setup_irods.sh\n 4.Execute B2SAFE install script as irods user: su -irods; cd /opt/eudat/b2safe/packaging/; ./install.sh\n"
 else 
  echo "The /etc/puppet directory wasn't replaced. Exiting." 
  exit 0 
 fi 

elif [ ! -d "$puppet_dir" ]; then 
  echo "The puppet directory doesn't exist. It will be created at /etc/puppet/ and B2SAFE module will be copied to it."
  cmd=`mv B2SAFE-puppet /etc/puppet`
  echo "======================================"
  printf "Next steps: \n 1.Edit /etc/puppet/parameters/common.yml \n 2.Run command: puppet apply --modulepath /etc/puppet/modules/ site.pp\n 3.Execute iRods setup script: /var/lib/irods/packaging/setup_irods.sh\n 4.Execute B2SAFE install script as irods user: su -irods; cd /opt/eudat/b2safe/packaging/; ./install.sh\n"
  exit 0 
fi 


