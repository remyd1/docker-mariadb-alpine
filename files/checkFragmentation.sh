#!/bin/sh

echo -n "MySQL username: " ; read username
echo -n "MySQL password: " ; stty -echo ; read password ; stty echo ; echo
export OPTIMIZE="";
mysql -u $username -p"$password" -NBe "SHOW DATABASES;" | grep -v 'lost+found' | while read database ; do
  mysql -u $username -p"$password" -NBe "SHOW TABLE STATUS;" $database | while read name engine version rowformat rows avgrowlength datalength maxdatalength indexlength datafree autoincrement createtime updatetime checktime collation checksum createoptions comment ; do
    if [ "$datafree" -gt 0 ] ; then
      fragmentation=$(($datafree * 100 / $datalength))
      echo "$database.$name is $fragmentation% fragmented"
      OPTIMIZE=${OPTIMIZE}"\nOPTIMIZE TABLE ${name};";
      echo ${OPTIMIZE};
#      echo -n "Should we optimize [y/n]: " ; read checkOptimize ; stty echo ; echo
#      if [ "${checkOptimize}" = "y" ]
#      then
#        mysql -u "$username" -p"$password" -NBe "OPTIMIZE TABLE $name;" "$database"
#      fi
    fi
  done
done
