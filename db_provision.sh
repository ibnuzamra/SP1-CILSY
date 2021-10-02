#!/bin/bash

# REPO UPDATE DAN INSTALASI PACKAGE
echo "Repo Update"
sudo apt update
echo "======================="

echo "Instalasi Database Server"
sudo apt install mysql-server -y
echo "Repo Update dan Instalasi Package Database Server Selesai"
echo "======================="

# KONFIGURASI MYSQL
echo "Konfigurasi MySQL pada File /etc/mysql/mysql.conf.d/mysqld.cnf"
sudo cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.bak
sudo sed -i "s/.*bind-address.*/bind-address = 10.10.17.11/" /etc/mysql/mysql.conf.d/mysqld.cnf
echo "Update bind address MySQL pada File /etc/mysql/mysql.conf.d/mysqld.cnf menjadi 10.10.17.11 untuk mengizinkan koneksi eksternal"
echo "======================="

echo "Restart Service Database Server"
sudo service mysql stop
sudo service mysql start
echo "Konfigurasi MySQL Selesai"
echo "======================="

# CREATE DATABASE & USER
sudo mysql << EOF
CREATE DATABASE IF NOT EXISTS dbsosmed;
CREATE DATABASE IF NOT EXISTS wordpress_db;
CREATE USER IF NOT EXISTS 'devopscilsy'@'%' IDENTIFIED BY '1234567890';
GRANT ALL PRIVILEGES ON *.* TO 'devopscilsy'@'%';
FLUSH PRIVILEGES;
EOF
echo "Create Database & User Selesai"
echo "======================="

# IMPORT DATABASE SOSIAL MEDIA
echo "Import Database untuk sosial-media"
git clone https://github.com/ibnuzamra/sosial-media.git
sudo mysql -u devopscilsy -p1234567890 dbsosmed < sosial-media/dump.sql
rm -rf sosial-media/
echo "Import Database Sosial Media Selesai"
echo "========================"