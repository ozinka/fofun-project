#!/bin/bash -xe
# logging setup
exec > >(tee /var/log/user-data.log|logger -s 2>/var/log/user-data-full.log) 2>&1

yum update -y

amazon-linux-extras install nginx1
systemctl enable nginx
service nginx start



###########################################
# Server command prompt customization     #
###########################################
# PS1
echo '' >> /etc/bashrc
echo '# Command prompt customization - $PS1' >> /etc/bashrc
echo 'if [ "`id -u`" -eq 0 ]; then' >> /etc/bashrc
echo '    PS1="\[$(tput bold)\]\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;11m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;10m\]${host_name}\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]:\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\] "' >> /etc/bashrc
echo 'else' >> /etc/bashrc
echo '    PS1="\u\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;10m\]${host_name}\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]:\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\] "' >> /etc/bashrc
echo 'fi' >> /etc/bashrc
# Handy aliases
echo 'alias ..="cd .."' >> /etc/bashrc
echo 'alias ..2="cd ../.."' >> /etc/bashrc
echo 'alias ..3="cd ../../.."' >> /etc/bashrc
echo 'alias ..4="cd ../../../.."' >> /etc/bashrc
echo 'alias ..5="cd ../../../../.."' >> /etc/bashrc