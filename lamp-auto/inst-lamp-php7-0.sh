# Auto install Lamp server with PHP version 7.0
sudo apt update
# Install Apache2
sudo apt install -y apache2
# Enabling mod_rewite
sudo a2enmod rewrite
sudo systemctl restart apache2
# Installing PHP 7.0
# Adding repository
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install -y php7.0 php7.0-common
# Install the additional packages
sudo apt install -y libapache2-mod-php7.0 php7.0-gd php7.0-mysql php7.0-mcrypt php7.0-soap php7.0-curl php7.0-intl php7.0-xsl php7.0-mbstring php7.0-zip php7.0-bcmath php7.0-iconv
# Test PHP version
php -v
sudo systemctl restart apache2
#Installing MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
#For specific version 
#sudo debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password password root'
#sudo debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server
# Provide a new mysql root password when asked. Then restart the server
sudo systemctl restart apache2
# Install phpmyadmin
# goto to directory where phpMyAdmin will be installed
cd /usr/share
# Download the version you need
# check up here for latest versions https://www.phpmyadmin.net/
sudo wget https://files.phpmyadmin.net/phpMyAdmin/4.6.5.2/phpMyAdmin-4.6.5.2-all-languages.zip
# install unzip
sudo apt install unzip
# Unzip dowloaded file
sudo unzip phpMyAdmin-4.6.5.2-all-languages.zip
# Rename the folder
sudo mv phpMyAdmin-4.6.5.2-all-languages phpmyadmin
# Change premissions
sudo chmod -R 0755 phpmyadmin
#
#CREATE FILE FOR APACHE VIRTUAL HOST
#
CONFIG="\n
<VirtualHost *:80>\n
\t ServerName localhost \n
\n
\t DocumentRoot /var/www \n
\n
\t Alias /phpmyadmin "/usr/share/phpmyadmin/" \n
\n
\t <Directory "/var/www"> \n
\t \t AllowOverride All \n
\t </Directory> \n
\n
</VirtualHost>
\n"
#
sudo rm /etc/apache2/sites-available/000-default.conf	
sudo touch /etc/apache2/sites-available/000-default.conf
echo -e $CONFIG | sudo tee -a /etc/apache2/sites-available/000-default.conf
#
sudo systemctl restart apache2
#
# install composer
sudo apt install -y composer
#
# install and configure xdebug
sudo apt install php-xdebug
#
XDEBUG_FILE="\n
zend_extension=xdebug.so\n
\n
xdebug.remote_enable=on \n
xdebug.remote_connect_back=1 \n
xdebug.remote_port = 9000 \n
xdebug.scream = 0 \n
xdebug.cli_color = 1 \n
xdebug.show_local_vars = 1 \n
xdebug.idekey=PHPSTORM \n
\n"
#
sudo rm /etc/php/7.0/mods-available/xdebug.ini
sudo touch /etc/php/7.0/mods-available/xdebug.ini
echo -e $XDEBUG_FILE | sudo tee -a /etc/php/7.0/mods-available/xdebug.ini
sudo systemctl restart apache2

