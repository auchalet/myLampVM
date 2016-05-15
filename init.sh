#!/bin/bash
# Using Debian Jessie

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
apt-get install -y php5-mcrypt php5-curl php5-intl php5-xdebug php5-xsl mcrypt

#
# MySQL with root:pass
#
debconf-set-selections <<< 'mysql-server mysql-server/root_password password pass'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password pass'
apt-get -q -y install mysql-server mysql-client php5-mysql 

#
# Utilities
#
apt-get install -y curl htop git vim tree make autoconf npm

#
# Composer for PHP
#
wget https://getcomposer.org/composer.phar
mv composer.phar /usr/local/bin/composer 

#
# Ruby gems
#
sudo apt-get install -y rubygems ruby-dev
apt-get install libsqlite3-dev
gem install mailcatcher

#
# Apache VHost
#
mkdir -p /var/www/application/
cd ~
echo '<VirtualHost *:80>
        DocumentRoot /var/www/application/
        ErrorLog  /var/www/projects-error.log
        CustomLog /var/www/projects-access.log combined
</VirtualHost>

<Directory "/var/www">
        Options Indexes Followsymlinks
        AllowOverride All
        Require all granted
</Directory>' > vagrant.conf

mv vagrant.conf /etc/apache2/sites-available
a2enmod rewrite > /dev/null

#
# Update PHP Error Reporting
#
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php5/apache2/php.ini
sed -i 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php5/apache2/php.ini
sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/apache2/php.ini
#  Append session save location to /tmp to prevent errors in an odd situation..
sed -i '/\[Session\]/a session.save_path = "/tmp"' /etc/php5/apache2/php.ini

#
# Reload apache
#
a2ensite vagrant
a2dissite 000-default
service apache2 restart

#
#  Cleanup
#
apt-get autoremove -y
usermod -a -G www-data vagrant

echo -e "------------------------------------------"
echo -e "Default Site is up at http://192.168.33.10"
echo -e "------------------------------------------"
