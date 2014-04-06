#!/bin/bash

GHOST_DIR=/var/www/ghost/content/
GHOST_CONFIG=/var/www/ghost/config.js
BACKUP_DIR=/home/ec2-user/backup/
BACKUP_RETENTION_PERIOD=10
LOG_FILE=/home/ec2-user/backup/backup-allghostthemes.log
DATE=`date '+%Y/%m/%Y-%m-%d-%H-%S'`

# Make backup directory
mkdir -p $BACKUP_DIR$DATE
touch $LOG_FILE

# Stop Ghost
pm2 stop ghost
echo "Ghost has been stopped - $DATE" >> $LOG_FILE

# Copy Ghost Database
cp -r $GHOST_DIR $BACKUP_DIR$DATE
cp $GHOST_CONFIG $BACKUP_DIR$DATE
echo "Ghost has been copied - $DATE" >> $LOG_FILE

# Start Ghost
cd /var/www/ghost/
pm2 start index.js --name ghost
echo "Ghost has been started - $DATE" >> $LOG_FILE

# Prune backup directory
#find "$BACKUP_DIR" -type d -mtime $BACKUP_RETENTION_PERIOD -iname '*.db' -delete
#find "$BACKUP_DIR" -type d -mtime +$BACKUP_RETENTION_PERIOD -delete
#echo "Backup directory pruned - $DATE" >> $LOG_FILE 

echo "Backup complete - $DATE">> $LOG_FILE
