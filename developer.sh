#!/bin/bash
PROJECT_CODE=mc
PROJECT_HOME=$HOME/workspace/repo/$PROJECT_CODE
mkdir -p $PROJECT_HOME
cd $PROJECT_HOME
git clone deployer@192.30.164.173:/opt/gitplace/projects/$PROJECT_CODE/custom_addons.git
cd custom_addons
git remote add nvcgitserver deployer@192.30.164.173:/opt/gitplace/projects/$PROJECT_CODE/custom_addons.git
git fetch nvcgitserver
#cd $PROJECT_HOME
#git clone deployer@192.30.164.173:/opt/gitplace/projects/$PROJECT_CODE/odoo-8.0
#cd odoo-8.0
#git remote add nvcgitserver deployer@192.30.164.173:/opt/gitplace/projects/$PROJECT_CODE/odoo-8.0
#git fetch nvcgitserver 
#git remote add nvcgitserver deployer@192.30.164.173:/opt/gitplace/projects/project2/custom_addons.git
#git remote add nvcgitserver deployer@192.30.164.173:/opt/gitplace/projects/project2/odoo-8.0
