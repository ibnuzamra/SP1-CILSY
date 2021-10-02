#!/bin/bash

# REPO UPDATE DAN INSTALASI PACKAGE
echo "Repo Update"
sudo apt update
echo "======================="

echo "Instalasi Nginx Web Server"
sudo apt install nginx -y
echo "========================"

echo "Instalasi PHP"
sudo apt install php-fpm php-mysql -y
echo "Repo Update dan Instalasi Package Web Server Selesai"
echo "======================="

# KONFIGURASI DIREKTORI WEB CONTENT
echo "Membuat Direktori Server Blocks"
sudo mkdir -p /var/www/welcome.local/html/
sudo mkdir -p /var/www/iwordpress.local/html/
sudo mkdir -p /var/www/isosmed.local/html/
echo "========================="

echo "Set Ownership Direktori Server Blocks"
sudo chown -R vagrant:vagrant /var/www/welcome.local/html/
sudo chown -R vagrant:vagrant /var/www/iwordpress.local/html/
sudo chown -R vagrant:vagrant /var/www/isosmed.local/html/
echo "========================="

echo "Set Permission Folder /var/www/"
sudo chmod -R 755 /var/www
echo "Konfigurasi Direktori Web Content Selesai"
echo "========================"

# CLONE SOURCE CODE
echo "Clone Source Code landing-page"
git clone https://github.com/ibnuzamra/landing-page.git
mv landing-page/* /var/www/welcome.local/html/
rm -rf landing-page
echo "========================"
 
echo "Clone Source Code WordPress"
git clone https://github.com/ibnuzamra/WordPress.git
mv WordPress/* /var/www/iwordpress.local/html/
rm -rf WordPress
sudo cp /var/www/iwordpress.local/html/wp-config-sample.php /var/www/iwordpress.local/html/wp-config.php
sudo sed -i 's/database_name_here/wordpress_db/g' /var/www/iwordpress.local/html/wp-config.php
sudo sed -i 's/username_here/devopscilsy/g' /var/www/iwordpress.local/html/wp-config.php
sudo sed -i 's/password_here/1234567890/g' /var/www/iwordpress.local/html/wp-config.php
sudo sed -i 's/localhost/10.10.17.11/g' /var/www/iwordpress.local/html/wp-config.php
echo "========================"

echo "Clone Source Code sosial-media"
git clone https://github.com/ibnuzamra/sosial-media.git
mv sosial-media/* /var/www/isosmed.local/html/
rm -rf sosial-media
sed -i 's/localhost/10.10.17.11/g' /var/www/isosmed.local/html/config.php
echo "Clone Source Code Selesai"
echo "========================"

# KONFIGURASI NGINX
echo "Konfigurasi Nginx"
sudo cp /vagrant/landing-page /etc/nginx/sites-available/landing-page
sudo cp /vagrant/wordpress /etc/nginx/sites-available/wordpress
sudo cp /vagrant/sosial-media /etc/nginx/sites-available/sosial-media
sudo ln -s /etc/nginx/sites-available/landing-page /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/sosial-media /etc/nginx/sites-enabled/
echo "========================"

echo "Restart Service"
sudo nginx -t
sudo nginx -s reload
sudo systemctl restart php7.4-fpm.service
sudo systemctl restart nginx.service
echo "Konfigurasi Nginx Selesai"
echo "========================"