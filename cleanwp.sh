#!/bin/bash

#
# Script to clean wordpress or Update to Latest Version
#
# @author   Luis Felipe <lfelipe1501@gmail.com>
# @website  https://www.lfsystems.com.co
# @version  1.0

#Color variables
W="\033[0m"
B='\033[0;34m'
R="\033[01;31m"
G="\033[01;32m"
OB="\033[44m"
OG='\033[42m'
UY='\033[4;33m'
UG='\033[4;32m'

#Check if you are in the directory where wordpress was installed
FILE='wp-config.php'
if [ -f "$FILE" ]; then

#get files and folders owner and group for actual wordpress installation
file_meta=($(ls -l $FILE)) 
file_owner="${file_meta[2]}" # get User
file_group="${file_meta[3]}" # get Group

echo -e "==================================\n$OB Wordpress Clean or Update$W \n=================================="

##Download Latest Wordpres
echo -e "$G>> Downloading$W Wordpress latest version....\n"
wget --progress=bar:force -c https://wordpress.org/latest.tar.gz -O wpltsv.tar.gz &&

##Extract Latest Wordpress
echo -e "Extracting files from Wordpress latest version in to$R wpltsv$W Folder\n$UY>> Wait a moment....$W\n"
mkdir wpltsv && chown -R $file_owner:$file_group wpltsv && tar -xzf wpltsv.tar.gz -C wpltsv &&

#Clean OLD Wordpress or Infected Files
echo -e "$OG installing, cleaning and placing the new wordpress files$W\n"
rm -rf wp-admin/ wp-includes/ .well-known/;
find . -maxdepth 1 ! -name 'wp-config.php' -type f \( -name 'wp-*.php' -o -name 'xmlrpc.php' -o -name 'index.php' \) -delete;

# check script is being run by root or normal user
if [[ $EUID -ne 0 ]]; then
    cp -r wpltsv/wordpress/* ./ && chown -R $file_owner:$file_group *;
else
    rsync --stats -a wpltsv/wordpress/* ./ && chown -R $file_owner:$file_group *;
fi

#Cleaning and deleting files and folders created by this script
rm -rf wpltsv*;
echo -e "\nCleaning and deleting files and folders created by this script\n$UG>> everything is ready!....$W\n"

else 
    echo -e "\n$FILE does not exist."
    echo -e "REMEMBER: in order to use this script, you must place it inside the folder where the WordPress was installed\nFor example:$B /var/www/html/wordp$W or$B /home/user/public_html$W"
    exit 1
fi
