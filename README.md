# S3Backup

Add the following line to crontab to have it run everyday at midnight

"00 00 * * * bash path/to/your/S3Backup.sh"


[?] Usage: ./S3Backup.sh [backup_directory] [directory_to_backup] [bucket] [email]

        [✙] Param1 <backup_directory>: The directory where the zipped backup is stored.
        [✙] Param2 <directory_to_backup>: The directory that will be zipped.
        [✙] Param3 <bucket>: The S3 bucket that will be uploaded to.
        [✙] Param4 <email>: The E-mail to send the final status to.
