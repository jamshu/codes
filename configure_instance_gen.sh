#!/bin/bash

#-------------------------------------------------------------------------------------------#
# CONFIGURE DEPENDS ON YOUR PROJECT...CHANGE IT AS PER YOUR PROJECT AND DESIRED PORT TO RUN #
#-------------------------------------------------------------------------------------------#
PROJECT_CODE=x1
XMLRPC_PORT_TEST=6060
XMLRPC_PORT_PROD=5050


#-------------------------------------------------------------#
# GENERAL CONFIGURATION...FILLED BY DEFAULT ...DONT CHANGE IT #
#-------------------------------------------------------------#
VPS_USER=nvcrunner
DB_USER=$VPS_USER
ADMIN_PASS=superadminpassword
CODE_REPO=/opt/projects
HOME=$CODE_REPO/$PROJECT_CODE
ODOO_VERSION=odoo-8.0 
DB_PASS=admin 


#sudo mkdir /var/log/$PROJECT_CODE
for TYPE in TEST PROD;do
OE_CONFIG=$PROJECT_CODE-$TYPE
file="/etc/$OE_CONFIG"
if [ -f /etc/$OE_CONFIG.conf ] 
then
  echo "project configuration with same project code already exists.check if any problem.This may be re run for the same configuration"
  exit 0
fi
ADDONS_PATH=$HOME/$TYPE/odoo_home/$ODOO_VERSION/addons,$HOME/$TYPE/odoo_home/$ODOO_VERSION/openerp/addons,$HOME/$TYPE/odoo_home/custom_addons
DAEMON=$HOME/$TYPE/odoo_home/$ODOO_VERSION
if [ $TYPE = "TEST" ]
then
	XMLRPC_PORT=$XMLRPC_PORT_TEST
else
	XMLRPC_PORT=$XMLRPC_PORT_PROD
fi
		

#sudo cp $CODE_REPO/$PROJECT_CODE/$TYPE/odoo_home/$ODOO_VERSION/debian/openerp-server.conf /etc/$OE_CONFIG.conf
sudo cp /opt/odoo/odoo-8.0/debian/openerp-server.conf /etc/$OE_CONFIG.conf
sudo chown $VPS_USER:$VPS_USER /etc/$OE_CONFIG.conf
sudo chmod 640 /etc/$OE_CONFIG.conf
echo -e "* Change server config file"
#editing configuration
sudo sed -i s/"db_user = .*"/"db_user = $DB_USER"/g /etc/$OE_CONFIG.conf
sudo sed -i s/"db_password = .*"/"db_password = $DB_PASS"/g /etc/$OE_CONFIG.conf
#sudo sed -i s/"addons_path"/"addons_path = $ADDONS_PATH"/g /etc/$OE_CONFIG.conf
#sudo sed -i s/"; admin_passwd.*"/"admin_passwd = $ADMIN_PASS"/g /etc/$OE_CONFIG.conf
#sudo sed -i s/"logfile = .*"/"logfile = /var/log/$PROJECT_CODE/$OE_CONFIG$1.log"/g /etc/$OE_CONFIG.conf
sudo su root -c "echo 'logfile = /var/log/$VPS_USER/$OE_CONFIG$1.log' >> /etc/$OE_CONFIG.conf"
#sudo su root -c "echo 'addons_path = $ADDONS_PATH' >> /etc/$OE_CONFIG.conf"
sudo sed -i "s|addons_path = .*|addons_path = $ADDONS_PATH|g" /etc/odoo-server.conf
sudo su root -c "echo 'xmlrpc_port = $XMLRPC_PORT' >> /etc/$OE_CONFIG.conf"
#creating instance
echo -e "* Create init file"
echo '#!/bin/sh' >> ~/$OE_CONFIG
echo '### BEGIN INIT INFO' >> ~/$OE_CONFIG
echo '# Provides: $OE_CONFIG' >> ~/$OE_CONFIG
echo '# Required-Start: $remote_fs $syslog' >> ~/$OE_CONFIG
echo '# Required-Stop: $remote_fs $syslog' >> ~/$OE_CONFIG
echo '# Should-Start: $network' >> ~/$OE_CONFIG
echo '# Should-Stop: $network' >> ~/$OE_CONFIG
echo '# Default-Start: 2 3 4 5' >> ~/$OE_CONFIG
echo '# Default-Stop: 0 1 6' >> ~/$OE_CONFIG
echo '# Short-Description: Enterprise Business Applications' >> ~/$OE_CONFIG
echo '# Description: ODOO Business Applications' >> ~/$OE_CONFIG
echo '### END INIT INFO' >> ~/$OE_CONFIG
echo 'PATH=/bin:/sbin:/usr/bin' >> ~/$OE_CONFIG
echo "DAEMON=$DAEMON/openerp-server" >> ~/$OE_CONFIG
echo "NAME=$OE_CONFIG" >> ~/$OE_CONFIG
echo "DESC=$OE_CONFIG" >> ~/$OE_CONFIG
echo '' >> ~/$OE_CONFIG
echo '# Specify the user name (Default: odoo).' >> ~/$OE_CONFIG
echo "USER=$DB_USER" >> ~/$OE_CONFIG
echo '' >> ~/$OE_CONFIG
echo '# Specify an alternate config file (Default: /etc/openerp-server.conf).' >> ~/$OE_CONFIG
echo "CONFIGFILE=\"/etc/$OE_CONFIG.conf\"" >> ~/$OE_CONFIG
echo '' >> ~/$OE_CONFIG
echo '# pidfile' >> ~/$OE_CONFIG
echo 'PIDFILE=/var/run/$NAME.pid' >> ~/$OE_CONFIG
echo '' >> ~/$OE_CONFIG
echo '# Additional options that are passed to the Daemon.' >> ~/$OE_CONFIG
echo 'DAEMON_OPTS="-c $CONFIGFILE"' >> ~/$OE_CONFIG
echo '[ -x $DAEMON ] || exit 0' >> ~/$OE_CONFIG
echo '[ -f $CONFIGFILE ] || exit 0' >> ~/$OE_CONFIG
echo 'checkpid() {' >> ~/$OE_CONFIG
echo '[ -f $PIDFILE ] || return 1' >> ~/$OE_CONFIG
echo 'pid=`cat $PIDFILE`' >> ~/$OE_CONFIG
echo '[ -d /proc/$pid ] && return 0' >> ~/$OE_CONFIG
echo 'return 1' >> ~/$OE_CONFIG
echo '}' >> ~/$OE_CONFIG
echo '' >> ~/$OE_CONFIG
echo 'case "${1}" in' >> ~/$OE_CONFIG
echo 'start)' >> ~/$OE_CONFIG
echo 'echo -n "Starting ${DESC}: "' >> ~/$OE_CONFIG
echo 'start-stop-daemon --start --quiet --pidfile ${PIDFILE} \' >> ~/$OE_CONFIG
echo '--chuid ${USER} --background --make-pidfile \' >> ~/$OE_CONFIG
echo '--exec ${DAEMON} -- ${DAEMON_OPTS}' >> ~/$OE_CONFIG
echo 'echo "${NAME}."' >> ~/$OE_CONFIG
echo ';;' >> ~/$OE_CONFIG
echo 'stop)' >> ~/$OE_CONFIG
echo 'echo -n "Stopping ${DESC}: "' >> ~/$OE_CONFIG
echo 'start-stop-daemon --stop --quiet --pidfile ${PIDFILE} \' >> ~/$OE_CONFIG
echo '--oknodo' >> ~/$OE_CONFIG
echo 'echo "${NAME}."' >> ~/$OE_CONFIG
echo ';;' >> ~/$OE_CONFIG
echo '' >> ~/$OE_CONFIG
echo 'restart|force-reload)' >> ~/$OE_CONFIG
echo 'echo -n "Restarting ${DESC}: "' >> ~/$OE_CONFIG
echo 'start-stop-daemon --stop --quiet --pidfile ${PIDFILE} \' >> ~/$OE_CONFIG
echo '--oknodo' >> ~/$OE_CONFIG
echo 'sleep 1' >> ~/$OE_CONFIG
echo 'start-stop-daemon --start --quiet --pidfile ${PIDFILE} \' >> ~/$OE_CONFIG
echo '--chuid ${USER} --background --make-pidfile \' >> ~/$OE_CONFIG
echo '--exec ${DAEMON} -- ${DAEMON_OPTS}' >> ~/$OE_CONFIG
echo 'echo "${NAME}."' >> ~/$OE_CONFIG
echo ';;' >> ~/$OE_CONFIG
echo '*)' >> ~/$OE_CONFIG
echo 'N=/etc/init.d/${NAME}' >> ~/$OE_CONFIG
echo 'echo "Usage: ${NAME} {start|stop|restart|force-reload}" >&2' >> ~/$OE_CONFIG
echo 'exit 1' >> ~/$OE_CONFIG
echo ';;' >> ~/$OE_CONFIG
echo '' >> ~/$OE_CONFIG
echo 'esac' >> ~/$OE_CONFIG
echo 'exit 0' >> ~/$OE_CONFIG

echo -e "* Security Init File"
sudo mv ~/$OE_CONFIG /etc/init.d/$OE_CONFIG


sudo chmod 755 /etc/init.d/$OE_CONFIG
sudo chown root: /etc/init.d/$OE_CONFIG
echo -e "* Start ODOO on Startup"
sudo update-rc.d $OE_CONFIG defaults
 
echo "Done! The ODOO server can be started with /etc/init.d/$OE_CONFIG"
done

