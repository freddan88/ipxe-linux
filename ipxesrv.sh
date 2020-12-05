#!/bin/bash
# Date: 2020-12-05
# Author: www.leemann.se/fredrik
#################
## Configuration:
root_user=root
root_group=root

## Please don´t change this:
root_folder=/srv/pxesrv

service_user=pxesrv
service_group=pxesrv

###################################################################################
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
    tftp_status=$(service tftpd-hpa status | grep Active)
    dhcp_status=$(service isc-dhcp-server status | grep Active)
    if [[ "$tftp_status" = *"(running)"* ]] || [[ "$dhcp_status" = *"(running)"* ]]; then
        echo "Service IPXE is currently running"
		echo " "
        exit
    fi
	echo "Starting ISC DHCP Server" && sleep 1
		service isc-dhcp-server start
	echo " "
	echo "Starting TFTPD HPA Server" && sleep 1
		service tftpd-hpa start
	echo " "
;;

stop)
	echo "Stopping ISC DHCP Server" && sleep 1
		service isc-dhcp-server stop
	echo " "
	echo "Stopping TFTPD HPA Server" && sleep 1
		service tftpd-hpa stop
	echo " "
;;

restart)
	echo " "
	$0 stop >/dev/null
	$0 start
;;

status)
	service isc-dhcp-server status
	service tftpd-hpa status
;;

perm)
	chown -R $root_user:$root_group $root_folder
	chown -R $service_user:$service_group $root_folder/pxe $root_folder/share 2>/dev/null
	find $root_folder -type d -exec chmod 0755 {} \;
	find $root_folder -type f -exec chmod 0764 {} \;
	chmod -R 775 $root_folder/pxe/pxe-boot
	chmod -R 775 $root_folder/tmp
;;

*)
	echo " "
	echo "Arguments: start|stop|restart|status|perm"
	echo "-----------------------------------------"
;;

esac
exit