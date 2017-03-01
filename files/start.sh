#!/bin/sh
mkdir -p /data/log/mysql
mkdir -p /data/db/mysql/
mkdir -p /data/conf
mkdir -p /var/run/mysqld
mkdir /run/mysqld

chown -R mysql: /data /var/run/mysqld

ln -sf /var/run/mysqld/mysqld.sock  /run/mysqld/mysqld.sock

if [ ! -f /data/conf/my.cnf ]; then
    mv /etc/mysql/my.cnf  /data/conf/my.cnf
fi

ln -sf /data/conf/my.cnf /etc/mysql/my.cnf
ln -sf /data/conf/my.cnf /etc/my.cnf
chmod o-r /etc/mysql/my.cnf /etc/my.cnf

if [ ! -f /data/db/mysql/ibdata1 ]; then

    mysql_install_db --defaults-file=/data/conf/my.cnf --user=mysql

    /usr/bin/mysqld_safe --defaults-file=/data/conf/my.cnf --user=mysql &
    sleep 10s

    mysql -u root --password="" <<-EOSQL
SET @@SESSION.SQL_LOG_BIN=0;
USE mysql;
DELETE FROM mysql.user ;
DROP USER IF EXISTS 'root'@'%','root'@'localhost','${DB_USER}'@'localhost','${DB_USER}'@'%';
CREATE USER 'root'@'%' IDENTIFIED BY '${DB_PASS}' ;
CREATE USER 'root'@'localhost' IDENTIFIED BY '${DB_PASS}' ;
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}' ;
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}' ;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%' WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'localhost' WITH GRANT OPTION ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOSQL

    killall mysqld
    killall mysqld_safe
    sleep 5s
    killall -9 mysqld
    killall -9 mysqld_safe
    sleep 5s
fi

mysqld_safe --defaults-file=/data/conf/my.cnf --user=mysql
