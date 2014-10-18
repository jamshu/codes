#!/bin/bash


PROJECT_CODE=x1
CODE_REPO=/opt/projects
HOME=$CODE_REPO/$PROJECT_CODE
ODOO_BASE=odoo-8.0
GIT_USER=deployer
GIT_SERVER_HOME=/opt/gitplace/projects
GIT_HOSTNAME=192.30.164.173
VPS_USER=nvcrunner
if [ -d $HOME ]; then
  echo "project directory with same project code already exists. change your project code"
  exit 1
fi
sudo mkdir -p $HOME/{PROD,TEST}
#sudo su $VPS_USER -c "mkdir -p $HOME/{PROD,TEST}"
cd $HOME
for dr in TEST PROD; do
	sudo mkdir -p $dr/odoo_bkps/{custom_addons,db_daily,db_deploymt,odoobase}
        sudo mkdir -p $dr/odoo_home
	#sudo su $VPS_USER -c "mkdir -p $dr/odoo_bkps/{custom_addons,db_daily,db_deploymt,odoobase}"	
	#sudo su $VPS_USER -c "mkdir -p $dr/odoo_home"
done

cd $HOME/TEST/odoo_home
sudo git clone $GIT_USER@$GIT_HOSTNAME:$GIT_SERVER_HOME/$PROJECT_CODE/custom_addons.git
cd custom_addons
sudo git checkout -b test
sudo git add .
sudo git commit -m "COMMIT AFTER SWITCHING TO THE BRANCH TEST"
sudo git remote add nvcgitserver $GIT_USER@$GIT_HOSTNAME:$GIT_SERVER_HOME/$PROJECT_CODE/custom_addons.git
#------------------------original setup --------------------------------------------------------------------------------#
#ssh -t $GIT_USER@$GIT_HOSTNAME "cd $GIT_SERVER_HOME/$PROJECT_CODE;sudo tar -zcvf $ODOO_BASE.tar.gz $ODOO_BASE ;exit" 
#sudo scp $GIT_USER@$GIT_HOSTNAME:$GIT_SERVER_HOME/$PROJECT_CODE/$ODOO_BASE.tar.gz $HOME/TEST/odoo_home
#----------------------------------end-----------------------------------------------------------------------------------#

#-------------------------Temporary for testiing purpose comment these in original vps and uncomment above original setup---#
cd /home/novizco/scripts
sudo cp latest/$ODOO_BASE.tar.gz $HOME/TEST/odoo_home
#-------------------------End------------------------------------------------------------------------------------------------#
cd $HOME/TEST/odoo_home
sudo cp $ODOO_BASE.tar.gz $HOME/PROD/odoo_home
sudo tar zxvf $ODOO_BASE.tar.gz
sudo rm $ODOO_BASE.tar.gz
cd $ODOO_BASE
echo "checking out to test branch base"
sudo git checkout test
sudo git add .
sudo git commit -m "COMMIT AFTER SWITCHING TO THE BRANCH TEST"
sudo git remote add nvcgitserver $GIT_USER@$GIT_HOSTNAME:$GIT_SERVER_HOME/$PROJECT_CODE/$ODOO_BASE
 
cd $HOME/PROD/odoo_home
sudo tar -zxvf $ODOO_BASE.tar.gz
sudo rm $ODOO_BASE.tar.gz
cd $ODOO_BASE
echo "checking out to prod branch base"
sudo git checkout prod
sudo git add .
sudo git commit -m "COMMIT AFTER SWITCHING TO THE BRANCH PROD"
sudo git remote add nvcgitserver $GIT_USER@$GIT_HOSTNAME:$GIT_SERVER_HOME/$PROJECT_CODE/$ODOO_BASE
cd $HOME/PROD/odoo_home
sudo git clone $GIT_USER@$GIT_HOSTNAME:$GIT_SERVER_HOME/$PROJECT_CODE/custom_addons.git
cd custom_addons
sudo git checkout -b prod
sudo git add .
sudo git commit -m "COMMIT AFTER SWITCHING TO THE BRANCH PROD"
sudo git remote add nvcgitserver $GIT_USER@$GIT_HOSTNAME:$GIT_SERVER_HOME/$PROJECT_CODE/custom_addons.git
cd
#sudo chmod 777 -R $HOME
sudo chown -R $VPS_USER:$VPS_USER $HOME/*
