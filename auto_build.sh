#!/bin/bash
#Purpose =Data build of odoo
#Created on 08-Oct-2014
#Author = Jamshid K
#email:jamshu.mkd@gmail.com
#mob no:+91 9744 894 950
#START
#LOG_FILE=log_file_name
############change below 3 values################
PROJECT_CODE=x1
BUILD_TYPE=TEST_CUSTOM                                   #select any of these(TEST_BASE, TEST_CUSTOM, PROD_BASE, PROD_CUSTOM)
DATABASE=x1_test
####################################
CODE_REPO=/opt/projects
HOME=$CODE_REPO/$PROJECT_CODE
ODOO_VERSION=odoo-8.0                                    #SELECT LIKE(ODOO HOME DIR NAME LIKE ODOO-8.0,ODOO-SAAS-5)
VPS_USER=nvcrunner
VPS_ROLE_PWD=admin
if [ "$BUILD_TYPE" = "TEST_BASE" ]
then
	INSTANCE=$PROJECT_CODE-TEST
	ODOO_HOME=$HOME/TEST/odoo_home/$ODOO_VERSION
	BKP_FOLDER=$HOME/TEST/odoo_bkps/odoobase
	DB_BKP_DR=$HOME/TEST/odoo_bkps/db_deploymt	
	DB_BKP=$HOME/TEST/odoo_bkps/db_deploymt/
	GIT_BRANCH=test
	MERGE_BRANCH=8.0
	REMOTE=
elif [ "$BUILD_TYPE" = "TEST_CUSTOM" ]
then
	INSTANCE=$PROJECT_CODE-TEST
	ODOO_HOME=$HOME/TEST/odoo_home/custom_addons
	BKP_FOLDER=$HOME/TEST/odoo_bkps/custom_addons
	DB_BKP_DR=$HOME/TEST/odoo_bkps/db_deploymt	
	DB_BKP=$HOME/TEST/odoo_bkps/db_deploymt/
	GIT_BRANCH=test
	MERGE_BRANCH=master
	
elif [ "$BUILD_TYPE" = "PROD_BASE" ]
then
	INSTANCE=$PROJECT_CODE-PROD
	ODOO_HOME=$HOME/PROD/odoo_home/$ODOO_VERSION
        BKP_FOLDER=$HOME/PROD/odoo_bkps/odoobase
	DB_BKP_DR=$HOME/PROD/odoo_bkps/db_deploymt
	DB_BKP=$HOME/PROD/odoo_bkps/db_deploymt/
	GIT_BRANCH=prod
	MERGE_BRANCH=test
elif [ "$BUILD_TYPE" = "PROD_CUSTOM" ]
then
	INSTANCE=$PROJECT_CODE-PROD
	ODOO_HOME=$HOME/PROD/odoo_home/custom_addons
      	BKP_FOLDER=$HOME/PROD/odoo_bkps/custom_addons
	DB_BKP_DR=$HOME/PROD/odoo_bkps/db_deploymt	
	DB_BKP=$HOME/PROD/odoo_bkps/db_deploymt/
	GIT_BRANCH=prod
	MERGE_BRANCH=test
fi	
echo "$BKP_FOLDER OUTSIDE"
code_backup() 
{ 
TIME=`date +"%d-%b-%y-%T"`            
FILENAME="$PROJECT_CODE-$TIME.tar.gz"    
#SRCDIR="/opt/projects/$PROJECT_CODE/TEST/odoo_home/custom_addons"                
#DESDIR="/opt/projects/$PROJECT_CODE/TEST/odoo_bkps/custom_addons"           
#tar -cpzf $DESDIR/$FILENAME $SRCDIR
echo $BKP_FOLDER
tar -cpzf $BKP_FOLDER/$FILENAME $ODOO_HOME
#cp $DESDIR/$FILENAME  $DESDIR/test_custom_addon_good.tar.gz
cp $BKP_FOLDER/$FILENAME  $BKP_FOLDER/good.tar.gz
if [ "$?" = "0" ]
then
    echo ""
    echo "                     $BUILD_TYPE Backup Created Successfully"
    echo ""
else
    echo ""
    echo "                     $BUILD_TYPE Backup Fails..............."
    echo ""
fi
 }
db_backup()
{
sudo service $INSTANCE stop
backup_date=`date +%Y-%m-%d_%H-%M`
for i in $DATABASE; do
  
    #backupfile=$DB_BKP$i.$backup_date.sql.gz
    backupfile=$DB_BKP$i-$backup_date.dump
    echo Dumping $i to $backupfile
    echo "Enter password as $VPS_ROLE_PWD"
    #pg_dump $i|gzip > $backupfile
   # sudo su $VPS_USER -c "pg_dump --cluster 9.1/main --format=c $i" > $backupfile
    sudo su $VPS_USER -c "pg_dump -Fc $i" > $backupfile
    cp $backupfile $DB_BKP_DR/good.dump
done

if [ "$?" = "0" ]
then
    echo ""
    echo "              $BUILD_TYPE Database Backup Completed Successfully"
    echo ""
else
    echo ""
    echo "              $BUILD_TYPE Database Backup FailS......................"
    echo ""
fi
sudo service $INSTANCE start
}
fetch()
{
CUR_TIME=`date +"%d-%b-%y-%T"`

echo "fetching New code"
cd $ODOO_HOME
echo $ODOO_HOME
sudo git checkout $GIT_BRANCH 
#sudo git add .
#sudo git commit -m "LAST COMMIT BEFORE PULL ON $CUR_TIME "
sudo git pull nvcgitserver $MERGE_BRANCH 
sudo git push nvcgitserver $GIT_BRANCH 

}
auto_build()
{
code_backup;
fetch;
db_backup;
exit 0;
}
auto_build;
