#!/bin/bash
# backup a specific FTP folder into tar archive, remove old backups
# (c) 2016 Benjamin Meinhold, polarvogel.de


# login information, paths and parameters
FTPserver=
FTPpath=""
# excludes separated by comma
FTPexcludes=""
FTPuser=""
FTPpassword=""

PREFIX="prefix_"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M")

BACKUPpath=""
BACKUPamount=5


# create and go to backup folder
[ ! -d $BACKUPpath ] && mkdir -p $BACKUPpath
cd $BACKUPpath


# download the FTP folder
wget -q -r -X $FTPexcludes -nH ftp://$FTPuser:$FTPpassword@$FTPserver$FTPpath



# remove old backups
if [ $(ls *.gz | wc -l) -ge $BACKUPamount ]
then
        # remove oldest
        oldestbackup="$(ls -tr *.gz | head -1)"
        rm $oldestbackup
fi



# tar, zip and remove downloaded FTP folder
newestfolder="$(ls -t | head -1)"
if [ -d $newestfolder ]
then
        tar -zcf $PREFIX$TIMESTAMP.tar.gz $newestfolder
        rm -r $newestfolder
fi
