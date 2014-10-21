#!/bin/sh
PROJECT_CODE=KV
CODE_REPO=/opt/projects
HOME=$CODE_REPO/$PROJECT_CODE
INSTANCES=$PROJECT_CODE-TEST $PROJECT_CODE-PROD
TEST_DB=first
PROD_DB=first
PROD_BKP_DR=$HOME/PROD/odoo_bkps/db_daily/
TEST_BKP_DR=$HOME/TEST/odoo_bkps/db_daily/
backup_date=`date +%Y-%m-%d_%H-%M`
VPS_USER=nvcrunner

for inst in $INSTANCES; do
	sudo service $inst stop
done

for i in $PROD_DB; do
  
   # backupfile=$PROD_BKP_DR$i.$backup_date.sql.gz
    #echo Dumping $i to $backupfile
    #pg_dump $i|gzip > $backupfile
	

    backupfile=$PROD_BKP_DR$i-$backup_date.dump
    echo Dumping $i to $backupfile
    #pg_dump $i|gzip > $backupfile
    #sudo su $VPS_USER -c "pg_dump --cluster 9.1/main --format=c $i" > $backupfile
    sudo su $VPS_USER -c "pg_dump -Fc $i" > $backupfile
  
done

for i in $TEST_DB; do
  
   # backupfile=$TEST_BKP_DR$i.$backup_date.sql.gz
   # echo Dumping $i to $backupfile
   # pg_dump $i|gzip > $backupfile
	#backupfile=$DB_BKP$i.$backup_date.sql.gz
    backupfile=$TEST_BKP_DR$i.$backup_date.dump
    echo Dumping $i to $backupfile
    #pg_dump $i|gzip > $backupfile
    #sudo su $VPS_USER -c "pg_dump --cluster 9.1/main --format=c $i" > $backupfile
  	sudo su $VPS_USER -c "pg_dump -Fc $i" > $backupfile
done

for inst in $INSTANCES; do
	sudo service $inst start
done
