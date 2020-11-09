#!/bin/bash

ROOT_SQL_PASS=foo123
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $ROOT_SQL_PASS"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $ROOT_SQL_PASS"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server


export DBPASS=1234567890

# MEMBUAT USER DI MYSQL
echo "Masukkan Password Root MYSQL"
sudo mysql -u root -p	<<CREATE_USER_QUERY
create user 'devopscilsy'@'localhost' identified by '1234567890';
grant all privileges on *.* to 'devopscilsy'@'localhost';
CREATE_USER_QUERY
echo "Membuat User devopscilsy di MySQL berhasil" 

# MEMBUAT DATABASE
echo "Masuk sebagai user devopscilsy di MySQL"
sudo mysql -u devopscilsy -p$DBPASS	<<CREATE_DB_QUERY
create database dbsosmed;
show databases;
CREATE_DB_QUERY

# IMPORT DATA
echo "Sedang import data ke dalam database"
sudo mysql -u devopscilsy -p$DBPASS dbsosmed < /vagrant/sosial-media/dump.sql
echo "Selesai Import DATABASE"
