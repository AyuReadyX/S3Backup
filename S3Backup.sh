#!/bin/bash
#
# Backup script for AWS S3 bucket
#
# Written by Sharod Richardson June 5, 2019

BACKUPDIR=$1
DIRTOBACKUP=$2
BUCKET=$3
EMAIL=$4

#
# Finds backups older than 7 days and removes them
#
purge_old_backups(){
    echo -e "Deleting backups older than 7 days"
    find $BACKUPDIR -type f -mtime +7 -name '*.zip' -execdir rm -- '{}' \;
}

#
# Zips the directory and appends timestamp to the
# name of the backup
#
zip_directory(){
    echo -e "Compressing the folder we are backing up"
    BACKUP_FILENAME=$(date "+mparticle-%Y-%m-%d_%H:%M:%S.zip")
    zip -r "$BACKUPDIR/$BACKUP_FILENAME" "$DIRTOBACKUP"  &> /dev/null
}

# 
# Copies the backup to the defined S3 bucket
#
copyto_s3(){
    echo -e "Copying compressed backup to AWS S3"
    aws s3 cp "$BACKUPDIR/$BACKUP_FILENAME" s3://$BUCKET/ &> /dev/null
}

# 
# Verify the backup has made it to S3
#
check_s3(){
    echo -e "Checking if the backup $BACKUP_FILENAME exists in S3"
    aws s3api head-object --bucket $BUCKET --key ''"$BACKUP_FILENAME"'' &> /dev/null
}

# 
# Send an email with the final status
#
send_email(){
    mail -s "Backup Status" $EMAIL <<< "$BACKUP_FILENAME successfully backed up to S3 Bucket" &> /dev/null
}

#
# Log the status to syslog
#
log_to_syslog(){
    logger "Backup $BACKUP_FILENAME successfully pushed to S3"
}

if [ $# -ne 4 ]; then
    echo -e "\t\n[\033[1m\u003F\033[0m] Usage: $0 <backup_directory> <directory_to_backup> <bucket> <email>\n"
    echo -e "\t[\u2719] Param1 <backup_directory>: The directory where the zipped backup is stored."
    echo -e "\t[\u2719] Param2 <directory_to_backup>: The directory that will be zipped."
    echo -e "\t[\u2719] Param3 <bucket>: The S3 bucket that will be uploaded to."
    echo -e "\t[\u2719] Param4 <email>: The E-mail to send the final status to.\n"
    exit 1
fi

#Removing old backups
purge_old_backups
if [ $? -eq 0 ]
then
  echo -e "Successfully deleted backups older than 7 days\n"
else
  echo -e "Didn't Delete Files" >&2
  exit 1
fi

#Zipping directory
zip_directory
if [ $? -eq 0 ]
then
  echo -e "Successfully zipped directory\n"
else
  echo -e "Failed to zip directory" >&2
  exit 1
fi

#Copying backup to S3
copyto_s3
if [ $? -eq 0 ]
then
  echo -e "Backup $BACKUP_FILENAME Successfully copied to S3\n"
else
  echo -e "Backup of $BACKUP_FILENAME Failed " >&2
  exit 1
fi

#Verifying file uploaded to S3
check_s3
if [ $? -eq 0 ]
then
  echo -e "$BACKUP_FILENAME present on S3\n"
else
  echo -e "$BACKUP_FILENAME is not present on S3" >&2
  exit 1
fi

#Logging to syslog
log_to_syslog
if [ $? -eq 0 ]
then
  echo -e "Successfully logged to syslog\n"
else
  echo -e "Error writing to syslog" >&2
  exit 1
fi

#Sending status email
send_email
if [ $? -eq 0 ]
then
  echo -e "Status e-mail successfully sent\n"
else
  echo -e "Error sending status e-mail" >&2
  exit 1
fi

