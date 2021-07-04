#!/bin/bash -xe
# logging setup
exec > >(tee /var/log/user-data.log|logger -s 2>/var/log/user-data-full.log) 2>&1

yum update -y

# Create SWAP file 3GB
dd if=/dev/zero of=/swapfile bs=128M count=24
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

# Install software
amazon-linux-extras install epel
yum install java-11-amazon-corretto byobu -y

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y
systemctl daemon-reload
systemctl start jenkins

amazon-linux-extras install nginx1 -y
systemctl enable nginx
service nginx start



###########################################
# Server command prompt customization     #
###########################################
# PS1
echo '' >> /etc/bashrc
echo '# Command prompt customization - $PS1' >> /etc/bashrc
echo 'if [ "`id -u`" -eq 0 ]; then' >> /etc/bashrc
echo '    PS1="\[$(tput bold)\]\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;11m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;10m\]fofun\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]:\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\] "' >> /etc/bashrc
echo 'else' >> /etc/bashrc
echo '    PS1="\u\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;10m\]fofun\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]:\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\] "' >> /etc/bashrc
echo 'fi' >> /etc/bashrc
# Handy aliases
echo 'alias ..="cd .."' >> /etc/bashrc
echo 'alias ..2="cd ../.."' >> /etc/bashrc
echo 'alias ..3="cd ../../.."' >> /etc/bashrc
echo 'alias ..4="cd ../../../.."' >> /etc/bashrc
echo 'alias ..5="cd ../../../../.."' >> /etc/bashrc