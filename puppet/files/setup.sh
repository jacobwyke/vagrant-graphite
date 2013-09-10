#!/bin/bash

###############################
#Install Packages
###############################
sudo apt-get install --assume-yes python-pip python-dev apache2 apache2-mpm-worker apache2-utils apache2.2-bin apache2.2-common libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libapache2-mod-wsgi libaprutil1-ldap memcached python-cairo-dev python-django python-ldap python-memcache python-pysqlite2 sqlite3 erlang-os-mon erlang-snmp rabbitmq-server bzr expect ssh libapache2-mod-python python-setuptools
sudo easy_install django-tagging

sudo /usr/bin/pip install whisper
sudo /usr/bin/pip install carbon
sudo /usr/bin/pip install graphite-web

###############################
#Carbon Setup
###############################
sudo cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf
sudo cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf

sudo echo " 
[stats] 
priority = 110 
pattern = .* 
retentions = 10:2160,60:10080,600:262974 
" >> /opt/graphite/conf/storage-schemas.conf


###############################
#Apache Config
###############################
HOSTNAME=$(hostname)
sudo echo "ServerName $HOSTNAME" > /etc/apache2/httpd.conf
sudo cp /vagrant/puppet/files/example-graphite-vhost.conf /etc/apache2/sites-available/default
sudo cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
sudo mkdir -p /etc/httpd/wsgi
sudo /etc/init.d/apache2 reload

###############################
#Database Creation
###############################
sudo cp /opt/graphite/webapp/graphite/local_settings.py.example /opt/graphite/webapp/graphite/local_settings.py
sudo python /opt/graphite/webapp/graphite/manage.py syncdb --noinput
sudo chown -R www-data:www-data /opt/graphite/storage/
sudo /etc/init.d/apache2 restart

###############################
#Start Carbon
###############################
sudo /opt/graphite/bin/carbon-cache.py start