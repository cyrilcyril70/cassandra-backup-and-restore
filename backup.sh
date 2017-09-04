
#!/bin/sh

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/opt/java/bin

#current date of the snapshot backup folder
DATE=`date +%Y%m%d%H%M%S`

#current date of the folder name
CURRENTDATE=`date +%d_%m_%Y`

#Create folder of the Current date with time for easy process to maintain the data backup
TIME=`date +%H_%M_%S`

#snapshot name with date 
SNAME="snapshot-$DATE"

#assign backup directory to create it 
BACKUPDIRECTORY="/home/ec2-user/backup/cassandra_db_snapshot/$CURRENTDATE/$TIME"

if [ ! -d "$BACKUPDIRECTORY" ]; then
        echo "Directory $BACKUPDIRECTORY not found, we are creating...folder for you...wait"
        sudo mkdir -p $BACKUPDIRECTORY
fi

if [ ! -d "$BACKUPDIRECTORY" ]; then
        echo "Directory $BACKUPDIRECTORY not found, exit..."
        exit
fi

echo "Snapshot name: $SNAME"

cd $BACKUPDIRECTORY
pwd
#rm -rf *

echo "keep tight and sit quiet we're taking snapshot 4 U"
#give the exact correct path to the NODETOOL and it'll process to take snapshot
/opt/cassandra/apache-cassandra-3.9/bin/nodetool -h 127.0.0.1 snapshot -t $SNAME
SFILES=`ls -1 -d /opt/cassandra/apache-cassandra-3.9/data/data/*/*/snapshots/$SNAME`
for f in $SFILES
do
        echo "Process snapshot $f"
        TABLE=`echo $f | awk -F/ '{print $(NF-2)}'`
        KEYSPACE=`echo $f | awk -F/ '{print $(NF-3)}'`

        if [ ! -d "$BACKUPDIRECTORY/$SNAME" ]; then
                mkdir $BACKUPDIRECTORY/$SNAME
        fi

        if [ ! -d "$BACKUPDIRECTORY/$SNAME/$KEYSPACE" ]; then
                mkdir $BACKUPDIRECTORY/$SNAME/$KEYSPACE
        fi
        #makes Directory in the backup Folder and replace the files and folders from the Cassandra path
        mkdir $BACKUPDIRECTORY/$SNAME/$KEYSPACE/$TABLE
        find $f -maxdepth 1 -type f -exec mv -t $BACKUPDIRECTORY/$SNAME/$KEYSPACE/$TABLE/ {} +
        
done

# u can delete the backup files after 6 hours of the daily backup (Optional)
#find /home/ec2-user/backup/cassandra_db_snapshot/* -maxdepth 0  -type d -mmin +360 -exec rm -rf {} \;

echo "done"


#TADA..all ur data's are taken backup.
#make ur backup as Cron_Job maintin ur backup 4 every 15_min maintin or 30_min
# */30 * * * * /home/ec2-user/backup/backup.sh
