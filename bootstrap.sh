#!/bin/bash

#Clearing the window
clear

ip="$(facter ipaddress)"
if cd /etc/puppetlabs/puppet/modules/nginx 2>/dev/null
    then
    echo "Nginx module already installed..."
    echo "Cut and paste $ip:8080 into your browser..."
    echo "...Or maybe you should just type it."

else
echo "Installing modules..."
puppet module install 7terminals/nginx &>/dev/null
puppet module install puppetlabs/vcsrepo &>/dev/null

cd /tmp

echo "Cloning manifest from Github..."
git clone https://github.com/xplainr/exercise-manifest.git &>/dev/null

echo "Replacing site.pp..."
mv -f /tmp/exercise-manifest/site.pp /etc/puppetlabs/puppet/manifests/

echo "Iniating Puppet run..."
puppet apply /etc/puppetlabs/puppet/manifests/site.pp &>/dev/null
echo "Puppet run complete..."

echo "Cleaning up..."
cd /tmp
rm -rf manifest_repo

echo "Restarting nginx..."
nginx
echo "Setup complete..."

echo "Cut and paste $ip:8080 into your browser..."
echo "...Or maybe you should just type it."
fi
