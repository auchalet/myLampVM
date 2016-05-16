#!/bin/bash
# Using Debian Jessie
# Remove "> /dev/null" to debug

apt-get update > /dev/null

# 
# @todo Set Locales
# 

#
# Apache & PHP
#
apt-get install -y sed apache2 libapache2-mod-php5 
sed -i -e '$a\ServerName localhost' /etc/apache2/apache2.conf

#
# More PHP
# 
apt-get install -y php5-mcrypt php5-curl php5-intl php5-xdebug php5-xsl mcrypt > /dev/null

#
# MySQL with root:pass
#
debconf-set-selections <<< 'mysql-server mysql-server/root_password password pass'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password pass'
apt-get -q -y install mysql-server mysql-client php5-mysql > /dev/null

#
# Utilities
#
apt-get install -y curl htop git vim tree make autoconf npm upstart > /dev/null

#
# Composer for PHP
#
wget https://getcomposer.org/composer.phar > /dev/null
mv composer.phar /usr/local/bin/composer 

#
# Ruby gems
#
sudo apt-get install -y rubygems ruby-dev
apt-get install libsqlite3-dev
gem install mailcatcher

#
# Copy config files where they belong
#
cp -rf /vagrant/config/mailcatcher.conf /etc/init/
cp -rf /vagrant/config/vagrant.conf /etc/apache2/sites-available
cp -rf /vagrant/config/mailcatcher.ini /etc/php5/mods-available
cp -rf /vagrant/config/php.ini /etc/php5/apache2/php.ini

#
# Apache VHost
#
mkdir -p /var/www/application/
a2enmod rewrite > /dev/null

#
# Reload apache and other services
#
a2ensite vagrant
a2dissite 000-default
php5enmod mailcatcher
service apache2 restart
service mailcatcher restart

#
#  Cleanup
#
apt-get autoremove -y
usermod -a -G www-data vagrant

echo -e "------------------------------------------"
echo -e "Default Site is up at http://192.168.33.10"
echo -e "------------------------------------------"
