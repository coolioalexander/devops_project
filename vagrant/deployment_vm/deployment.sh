#!/bin/bash

# Jenkins

echo "Adding apt-keys"
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list

echo "Updating apt-get"
sudo apt-get -qq update

echo "Installing default-java"
sudo apt-get -y install default-jre > /dev/null 2>&1
sudo apt-get -y install default-jdk > /dev/null 2>&1

echo "Installing git"
sudo apt-get -y install git > /dev/null 2>&1

echo "Installing git-ftp"
sudo apt-get -y install git-ftp > /dev/null 2>&1

echo "Installing jenkins"
sudo apt-get -y install jenkins > /dev/null 2>&1
sudo service jenkins start

echo "Updating apt-get"
sudo apt-get -qq update

# Ansible

echo "Installing dependencies"
sudo apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    python3-pip \
    python-pip \
    virtualenv \
    python3-setuptools > /dev/null 2>&1

echo "Adding repository"
sudo apt-add-repository --yes --update ppa:ansible/ansible

echo "Installing ansible"
sudo apt-get -y install ansible > /dev/null 2>&1

# Docker

echo "Installing docker"
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get -qq update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common > /dev/null 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get -qq update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io > /dev/null 2>&1
sudo groupadd docker
sudo usermod -aG docker jenkins
sudo usermod -aG docker vagrant
chmod root:docker /var/run/docker.sock

echo "Installing docker module for python3 and python2"
pip3 install docker
pip install docker

sleep 1m

echo "Installing Jenkins Plugins"
JENKINSPWD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
echo $JENKINSPWD

echo "Please remenber to add jenkins & vagrant users to group docker and reboot machine..."
echo "\
    $ vagrant ssh \
    $ sudo groupadd docker \
    $ sudo usermod -aG docker jenkins \
    $ sudo usermod -aG docker vagrant \
    $ sudo reboot"