#!/bin/bash
STORAGE_ACCOUNT_NAME=""
STORAGE_ACCOUNT_KEY=""
FILE_SHARE_NAME=""
LOCAL_FOLDER=""

# Install the cifs utils
sudo apt-get update
sudo apt-get -y install cifs-utils

# Create the local folder that will contain the share
if [ ! -d $LOCAL_FOLDER ]; then 
	sudo mkdir -p $LOCAL_FOLDER
	# Add the share to fstab so it will be remounted after reboot
	sudo echo "//$STORAGE_ACCOUNT_NAME.file.core.windows.net/$FILE_SHARE_NAME	$LOCAL_FOLDER	cifs	vers=3.0,username=$STORAGE_ACCOUNT_NAME,password=$STORAGE_ACCOUNT_KEY,_netdev,dir_mode=0777,file_mode=0777" >> /etc/fstab 
	# Mount the new share
	sudo mount $LOCAL_FOLDER
fi

echo "done"