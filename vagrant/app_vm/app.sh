#!/bin/bash

# Ansible 

echo "Updating apt-get"
sudo apt-get -qq update

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
sudo usermod -aG docker vagrant
chmod root:docker /var/run/docker.sock

# Docker module for python

echo "Installing docker module for python3 and python2"
pip3 install docker
pip install docker

# Kubernetes : Minikube & Kubectl

echo "Updating apt-get"
sudo apt-get -qq update

echo "Installing dependencies"
sudo apt-get -y install curl \
    virtualbox \ 
    virtualbox-ext-pack > /dev/null 2>&1

echo ""
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

echo ""
chmod +x minikube

echo ""
sudo mv -v minikube /usr/local/bin

echo ""
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl

echo ""
chmod +x kubectl

echo ""
sudo mv -v kubectl /usr/local/bin

echo ""
minikube start

sleep 1m

# Post-provisioning : rebooting

echo "Please remenber to add user to group docker and reboot machine..."
echo "\
    $ vagrant ssh \
    $ sudo groupadd docker \
    $ sudo usermod -aG docker vagrant \ 
    $ sudo reboot"