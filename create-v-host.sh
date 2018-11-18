# START
#
read -p "Do you want to create virtual host? (y/n) " answer
#
if [ "$answer" = "n" ]
then
	exit
fi
if [ "$answer" = "y" ]
then
	read -p "Enter project name: " project
	#
	#CREATE FILE FOR APACHE VIRTUAL HOST
	#
	CONFIG="\n
	<VirtualHost *:80>\n
	\t ServerName $project.loc \n
	\t php_value display_errors 1
	\n
	\t DocumentRoot /var/www/$project \n
	\n
	\t <Directory "/var/www/$project"> \n
	\t \t AllowOverride All \n
	\t </Directory> \n
	\n
	</VirtualHost>
	\n"
	#
	sudo touch /etc/apache2/sites-available/$project.conf
	#
	echo
	echo "Writing file for virtual host:"
	echo
	#
	echo -e $CONFIG | sudo tee -a /etc/apache2/sites-available/$project.conf
	#
	#ENABLING FILE
	#
	sudo a2ensite $project.conf
	#
	echo -e "127.0.0.1 \t $project.loc" | sudo tee -a /etc/hosts
	#
	sudo systemctl restart apache2
fi
