# cassandra backup and restore

# simple process for cassandra Backup and restore 

# use the backup.sh for create and make ur own snapshot with date and time 

# use restore.sh for restore single table into the keyspace

# use multiple_restore.sh for restore multiple table into the keyspace(it's simliar to restore.sh)

# use cron_job for backup

# table backup for every 15 or 30 min

# Delete ur backup files after 6 hours, use the below cmd if needed

# find /home/ec2-user/backup/cassandra_db_snapshot/* -maxdepth 0  -type d -mmin +360 -exec rm -rf {} \;
