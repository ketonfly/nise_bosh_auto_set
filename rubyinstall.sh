#!/bin/bash

# !!! something important about permission!!!


if [ ! `which gcc` ]; then
  if [ `ls | grep sources.list` ]; then
    sudo cp sources.list /etc/apt/sources.list
    sudo apt-get update
    rm sources.list
  fi
  sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install gcc
fi

sudo apt-get -y install build-essential libssl-dev libreadline-gplv2-dev zlib1g-dev git-core libxslt-dev libxml2-dev

sudo mkdir -p /var/vcap/bosh
sudo mkdir -p /var/vcap/packages
sudo mkdir -p /var/vcap/jobs

sudo cp yaml-0.1.4.tar.gz /var/vcap/packages
sudo cp ruby-1.9.3-p448.tar.gz /var/vcap/packages
sudo cp rubygems-1.8.17.tgz /var/vcap/packages


#yaml install
cd /var/vcap/packages
sudo tar xzf yaml-0.1.4.tar.gz
cd yaml-0.1.4
sudo ./configure --prefix=/var/vcap/bosh
sudo make
sudo make install
export PATH=/var/vcap/bosh/bin:$PATH

#ruby install

cd /var/vcap/packages
if [ ! -d ruby-1.9.3-p448 ]; then
  sudo tar xzf ruby-1.9.3-p448.tar.gz
fi

cd ruby-1.9.3-p448
if ! (which ruby); then
  sudo ./configure --prefix=/var/vcap/bosh --enable-shared --disable-install-doc --with-opt-dir=/usr/local/lib --with-openssl-dir=/usr --with-readline-dir=/usr --with-zlib-dir=/usr
  sudo make
  sudo make install
fi
export PATH=/var/vcap/bosh/bin:$PATH

#rubygems install
cd /var/vcap/packages
sudo tar xzf rubygems-1.8.17.tgz
cd rubygems-1.8.17
sudo ruby setup.rb
export PATH=/var/vcap/bosh/bin:$PATH

#set blob files
cd /home/vcap
tar xzf adeploy.gz
mkdir vcap
mv  /home/vcap/adeploy/deploy /home/vcap/vcap/
sudo mv  /home/vcap/adeploy/vcap /var


#install gem packages
sudo gem install bundler
sudo gem install rake

#get gem dependent files
cd /home/vcap/vcap/deploy/nise_bosh/
bundle install
#ERROR,solution

#install bosh
sudo gem install bosh_cli
