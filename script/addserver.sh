
#!/bin/bash


PS3="Pilih mau pasang yang mana : "
pilihan=("Apache2" "Nginx" "Mysql-Server" "MongoDB" "Keluar")


select opt in "${pilihan[@]}"
do   
	case $opt in
		"Apache2")
                  sudo apt update 
                  sudo apt install apache2 -y
		  break
                  ;;
                 "Nginx")
                  sudo apt update
                  sudo apt install nginx git -y
       		  sudo add-apt-repository universe
		  sudo apt install php-fpm php-mysql -y
		  sudo cp default /etc/nginx/sites-enabled/default
		  sudo systemctl restart nginx
		  sudo cp index.php /var/www/html/index.php
		  cd /var/www/html/  && sudo rm -Rf * && sudo git clone https://github.com/yasinbudi12/sosial-media.git .
                  break
                  ;;
"Mysql-Server")
sudo apt update
#sudo apt install mysql-server -y

ROOT_SQL_PASS=foo123
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $ROOT_SQL_PASS"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $ROOT_SQL_PASS"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server


export DBPASS=1234567890

# MEMBUAT USER DI MYSQL
echo "Masukkan Password Root MYSQL"
sudo mysql -u root -p   <<CREATE_USER_QUERY
create user 'devopscilsy'@'localhost' identified by '1234567890';
grant all privileges on *.* to 'devopscilsy'@'localhost';
CREATE_USER_QUERY
echo "Membuat User devopscilsy di MySQL berhasil" 

# MEMBUAT DATABASE
echo "Masuk sebagai user devopscilsy di MySQL"
sudo mysql -u devopscilsy -p$DBPASS     <<CREATE_DB_QUERY
create database dbsosmed;
show databases;
CREATE_DB_QUERY

# IMPORT DATA
echo "Sedang import data ke dalam database"
sudo mysql -u devopscilsy -p$DBPASS dbsosmed < /vagrant/sosial-media/dump.sql
echo "Selesai Import DATABASE"                  break
                  ;;
                 "MongoDB")
                  sudo apt update 
                  sudo apt install mongodb -y
                  ;;
		 "Keluar")
                  break
                  ;;
                  *) echo "Pilihan tidak ada"
                  ;;
	esac

done
