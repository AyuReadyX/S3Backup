# S3Backup
![](https://img.shields.io/badge/S3Backup-bash-green.svg)


#### Dependencies:
```bash
apt install aws
```

Make the script executable `chmod +x S3Backup.sh`


Add the following line to crontab to have it run everyday at 2AM
"0 2 * * * bash /path/to/your/S3Backup.sh"


[?] Usage: S3Backup.sh [backup_directory] [directory_to_backup] [bucket] [email]

        [✙] Param1 <backup_directory>: The directory where the zipped backup is stored.
        [✙] Param2 <directory_to_backup>: The directory that will be zipped.
        [✙] Param3 <bucket>: The S3 bucket that will be uploaded to.
        [✙] Param4 <email>: The E-mail to send the final status to.
