#!/bin/bash -xe
# logging setup
exec > >(tee /var/log/user-data.log|logger -s 2>/var/log/user-data-full.log) 2>&1

yum update -y
amazon-linux-extras install epel

# Create SWAP file 5GB
dd if=/dev/zero of=/swapfile bs=128M count=40
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

# Install software
amazon-linux-extras install epel
yum install java-11-amazon-corretto byobu git dos2unix htop -y

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y
systemctl daemon-reload
systemctl start jenkins

amazon-linux-extras install nginx1 -y
systemctl enable nginx
service nginx start

# install NODE.js
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash -
yum install -y nodejs

###########################################
# Server command prompt customization     #
###########################################
# PS1
aws s3 cp s3://fofun/conf/ps1.sh /etc/ps1.sh
dos2unix /etc/ps1.sh

sudo cat >> /etc/bashrc <<EOL

# Command prompt customization - $PS1
source /etc/ps1.sh
EOL

# Handy aliases
echo 'alias ..="cd .."' >> /etc/bashrc
echo 'alias ..2="cd ../.."' >> /etc/bashrc
echo 'alias ..3="cd ../../.."' >> /etc/bashrc
echo 'alias ..4="cd ../../../.."' >> /etc/bashrc
echo 'alias ..5="cd ../../../../.."' >> /etc/bashrc