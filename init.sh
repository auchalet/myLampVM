#!/bin/bash
# Using Trusty64 Ubuntu

# expects no interactive input at all
export DEBIAN_FRONTEND=noninteractive

#
# Apache
#
apt-get update > /dev/null
apt-get install -y sed apache2 libapache2-mod-php5
sed -i -e '$a\ServerName localhost' /etc/apache2/apache2.conf

# Set Locales
apt-get install locales
export LANGUAGE=fr_FR.UTF-8
export LANG=fr_FR.UTF-8
export LC_ALL=fr_FR.UTF-8
locale-gen fr_FR.UTF-8
dpkg-reconfigure locales

#
# PHP
#
apt-get install -y php5 php5-cli php5-dev php5-mcrypt php5-curl php5-intl php5-xdebug php5-common php5-xsl mcrypt

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
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '41e71d86b40f28e771d4bb662b997f79625196afcca95a5abf44391188c695c6c1456e16154c75a211d238cc3bc5cb47') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer 

#
# Apache VHost
#
mkdir -p /vagrant/www/application/
cd ~
echo '<VirtualHost *:80>
        DocumentRoot /vagrant/www/application/
        ErrorLog  /vagrant/www/projects-error.log
        CustomLog /vagrant/www/projects-access.log combined
</VirtualHost>

<Directory "/vagrant/www">
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

echo -e "----------------------------------------"
echo -e "Now to finish install:\n"
echo -e "----------------------------------------"
echo -e "$ cd /vagrant/www"
echo -e "$ composer install\n"
echo -e
echo -e "Then follow the README.md\n"

echo -e "----------------------------------------"
echo -e "Default Site: http://192.168.33.10"
echo -e "----------------------------------------"
