#!/bin/sh

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/opt/java/bin

echo "Welcome to cassandra Restore Process"

#Main Directory upto your Database_name
MAINDIRECTORY="/opt/cassandra/apache-cassandra-3.9/data/data/nsa"

#date of ur backup
DATEOFBACKUP="01_09_2017"

#time of ur backup on the date of the backup
TIMEOFBACKUP="19_04_57"

#snapshot id of the backup
SNAPSHOT_ID="snapshot-20170901190457"

#database_name
DB_NAME="nsa"

#assign to ur backup directory upto the database(keyspace) name which u want 2 replace
BACKUPDIRECTORY="/home/ec2-user/backup/cassandra_db_snapshot/$DATEOFBACKUP/$TIMEOFBACKUP/$SNAPSHOT_ID/$DB_NAME"

echo "$BACKUPDIRECTORY"

#table name which u want to replace
A1="calendar_data-7935e4d08d9811e786756fe3109cdf0a"

cd "$MAINDIRECTORY/$A1"
echo "Restoring in "
pwd
#delete all the files and folder in the Main Directory and ignores the SNAPSHOT folder
shopt -s extglob
rm -rf !(snapshots)

#replace or copy the snapshot into the Cassandra Database Directory
cp "$BACKUPDIRECTORY/$A1/"* "$MAINDIRECTORY/$A1"

echo "Restore done Sucessfully"


#After starting or before starting use "nodetool repair" and delete the commit_log files..
#now again restart ur cassandra server...
#TADA..U can find the all ur data's again.