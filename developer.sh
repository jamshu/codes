#!/bin/bash
PROJECT_CODE=alpha
PROJECT_HOME=$HOME/workspace/$PROJECT_CODE
mkdir -p $PROJECT_HOME
cd $PROJECT_HOME
git clone deployer@192.30.164.173:/opt/gitplace/projects/$PROJECT_CODE/custom_addons.git
cd custom_addons
git remote add nvcgitserver deployer@192.30.164.173:/opt/gitplace/projects/$PROJECT_CODE/custom_addons.git
git fetch nvcgitserver
#For base
#cd $PROJECT_HOME
#git clone deployer@192.30.164.173:/opt/gitplace/projects/$PROJECT_CODE/odoo-8.0
#cd odoo-8.0
#git remote add nvcgitserver deployer@192.30.164.173:/opt/gitplace/projects/$PROJECT_CODE/odoo-8.0
#git fetch nvcgitserver 

