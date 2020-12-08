#!/bin/bash
# Date: 2020-12-05
# Author: www.leemann.se/fredrik
#################
## Configuration:
tftp_folder=/srv/tftp
tftp_group=nogroup
tftp_user=tftp
http_folder=/var/www/html
http_group=www-data
http_user=www-data
##############################
if [ "$(id -u)" != "0" ]; then
echo " "
echo "PLEASE RUN THIS SCRIPT AS ROOT OR SUDO!"
echo "---------------------------------------"
exit
fi
##########
case $1 in

start)
echo " "
	tftp_status=$(systemctl is-active tftpd-hpa.service)
	dhcp_status=$(systemctl is-active isc-dhcp-server.service)
	if [[ "$tftp_status" = "active" ]] || [[ "$dhcp_status" = "active" ]]; then
		echo "Service IPXE is currently running"
		echo " "
		exit
	fi
	echo "Starting ISC DHCP Server" && sleep 1
	systemctl start isc-dhcp-server.service
echo " "
	echo "Starting TFTPD HPA Server" && sleep 1
	systemctl start tftpd-hpa.service
echo " "
;;

stop)
echo " "
	echo "Stopping ISC DHCP Server" && sleep 1
	systemctl stop isc-dhcp-server.service
echo " "
	echo "Stopping TFTPD HPA Server" && sleep 1
	systemctl stop tftpd-hpa.service
echo " "
;;

restart)
echo " "
	$0 stop >/dev/null
	$0 start >/dev/null
	echo "Service IPXE restarted"
echo " "
;;

status)
echo " "
	systemctl status isc-dhcp-server.service | head -3
echo " "
	systemctl status tftpd-hpa | head -3
echo " "
;;

perm)
echo " "
	chown -R $tftp_user:$tftp_group $tftp_folder
	chown -R $http_user:$http_group $http_folder
	find $tftp_folder -type d -exec chmod 0755 {} \;
	find $tftp_folder -type f -exec chmod 0744 {} \;
	find $http_folder -type d -exec chmod 0755 {} \;
	find $http_folder -type f -exec chmod 0764 {} \;
	echo "Changing permissions and owner on: $tftp_folder"
	echo " "
	echo "Changing permissions and owner on: $http_folder"
echo " "
;;

enable)
echo " "
	echo "Enabling autostart and starting services"
	echo "----------------------------------------"
	systemctl enable isc-dhcp-server
	echo " "
	systemctl enable tftpd-hpa
	$0 start >/dev/null
echo " "
;;

disable)
echo " "
	echo "Disabling autostart and stopping services"
	echo "-----------------------------------------"
	systemctl disable isc-dhcp-server
	echo " "
	systemctl disable tftpd-hpa
	$0 stop >/dev/null
echo " "
;;

*)
	echo " "
	echo "Arguments: start|stop|restart|status|perm|enable|disable"
	echo "--------------------------------------------------------"
;;

esac
exit