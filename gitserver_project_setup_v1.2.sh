#!/bin/bash
#SET THE PROJECT SPECIFIC CODE BELOW
#ODOO_SRC=/opt/gitplace/odoo-8.0
ODOO_SRC=/opt/odoo_bases/odoo-8.0
PROJECT_CODE=x2
GIT_HOME=/opt/gitplace/projects
ODOO_BASE=$GIT_HOME/$PROJECT_CODE/odoo-8.0

#Create a directory with project_code under /opt/gitplace/ (eg:- /opt/gitplace/kv)
##### we need to check if the directory exists already, if yes program should exit. It should never overwrite existing directory
if [ -d $GIT_HOME/$PROJECT_CODE ]; then
  echo "project directory with same project code already exists. change your project code"
  exit 1
fi
mkdir $GIT_HOME/$PROJECT_CODE
echo "created directory" $GIT_HOME/$PROJECT_CODE

#Create a directory staging under /opt/gitplace/$PROJECT_CODE and create directory custom_addons under that
mkdir $GIT_HOME/$PROJECT_CODE/staging
echo "created directory" $GIT_HOME/$PROJECT_CODE/staging
mkdir $GIT_HOME/$PROJECT_CODE/staging/custom_addons
echo "created directory" $GIT_HOME/$PROJECT_CODE/staging/custom_addons


#Copy odoo base from $ODOO_SRC to /opt/gitplace/$PROJECT_CODE/odoo-8.0
cd $GIT_HOME/$PROJECT_CODE
echo "copying odoo base from "$ODOO_SRC to $GIT_HOME/$PROJECT_CODE
cp -Rf $ODOO_SRC $GIT_HOME/$PROJECT_CODE


#Add branches test and prod to the repository /opt/gitplace/$PROJECT_CODE/odoo-8.0
echo "creating test, prod branches in  odoo base at " $ODOO_BASE
cd $ODOO_BASE
git branch test
git branch prod 

echo "branches created. Now branches present in odoo base are"
git branch

#Go to /opt/gitplace/$PROJECT_CODE/staging/custom_addons and add a new initial file to it. 
cd $GIT_HOME/$PROJECT_CODE/staging/custom_addons
echo "creating the initial file firstfile.txt in " $GIT_HOME/$PROJECT_CODE/staging/custom_addons
echo "Initial file. To be deleted later" > firstfile.txt

#Initialize /opt/gitplace/$PROJECT_CODE/staging/custom_addons for git
echo "Initialize" $GIT_HOME/$PROJECT_CODE/staging/custom_addons "for git and commit firstfile.txt"
git init
git add firstfile.txt
git commit -m "Initial setup. adding firstfile.txt"

#Add branches test and prod to the repository at the master position in /opt/gitplace/$PROJECT_CODE/staging/custom_addons
echo "creating test, prod branches in" $GIT_HOME/$PROJECT_CODE/staging/custom_addons
git branch test
git branch prod
echo "branches created. Now branches present in custom_addons are"
git branch

#Clone custom_addons to make their bare git directories 
echo "cloning custom_addons to make their bare git directories in "$GIT_HOME/$PROJECT_CODE/custom_addons.git
cd $GIT_HOME/$PROJECT_CODE/staging
git clone --bare custom_addons $GIT_HOME/$PROJECT_CODE/custom_addons.git

#Now remove the staging folder
echo "removing the directory" $GIT_HOME/$PROJECT_CODE/staging
rm -rf $GIT_HOME/$PROJECT_CODE/staging
