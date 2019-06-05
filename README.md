#S3Backup
1. crontab -e and add the following line to run it everyday at mightnight

00 00 * * * sh path/to/S3Backup.sh

#Usage: ./S3Backup.sh <backup_directory> <directory_to_backup> <bucket> <email>
        
        [✙] Param1 <backup_directory>: The directory where the zipped backup is stored.
        [✙] Param2 <directory_to_backup>: The directory that will be zipped.
        [✙] Param3 <bucket>: The S3 bucket that will be uploaded to.
        [✙] Param4 <email>: The E-mail to send the final status to.
