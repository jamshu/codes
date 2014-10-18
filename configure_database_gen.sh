#!/bin/bash


#----------------------------------------------------------------------------------------------------------------------------------#
# YOU SHOULD SELECT ANY OF THE TYPE FROM (TEST/PROD) DEFAULT FILLED BY TEST CHANGE TO PROD IF YOU WANT TO CONFIGURE FOR PRODUCTION #
#----------------------------------------------------------------------------------------------------------------------------------#

TYPE=TEST
#-------------------------------------------------------------------------------------------#
# CONFIGURE DEPENDS ON YOUR PROJECT...CHANGE IT AS PER YOUR PROJECT AND CREATED DATA BASE NAME  #
#-------------------------------------------------------------------------------------------#
PROJECT_CODE=x1
DB_NAME=x1_test
DB_FILTER=x1_test


#-------------------------------------------------------------#
# GENERAL CONFIGURATION...FILLED BY DEFAULT ...DONT CHANGE IT #
#-------------------------------------------------------------#

OE_CONFIG=$PROJECT_CODE-$TYPE


sudo su root -c "echo 'db_filter = $DB_FILTER' >> /etc/$OE_CONFIG.conf"
sudo su root -c "echo 'db_name = $DB_NAME' >> /etc/$OE_CONFIG.conf"
echo "Configuration updated "
sudo service $OE_CONFIG restart
exit 0
