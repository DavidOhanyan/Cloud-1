#!/bin/bash

service mysql start 

echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DB ;" > db.sql
echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" >> db.sql
echo "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USER'@'%' ;" >> db.sql
echo "FLUSH PRIVILEGES;" >> db.sql

mysql < db.sql

sleep 2

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld