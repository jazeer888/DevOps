#!/bin/bash

# Database credentials
DB_HOST="hostname"
DB_NAME="dbname"

# Azure Storage settings
AZURE_STORAGE_ACCOUNT="your_storage_account_name"
AZURE_STORAGE_CONNECTION_STRING="your_storage_account_key"
AZURE_CONTAINER_NAME="database-backups"

# Create backup directory if it doesn't exist
BACKUP_DIR="/home/dgv-mvp-mysql/backups"
mkdir -p $BACKUP_DIR

# Generate timestamp for filename
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.sql"

# Perform the backup
echo "Starting backup of database $DB_NAME..."
mysqldump -h $DB_HOST --routines --single-transaction --no-create-db $DB_NAME > $BACKUP_FILE
#for taking a backup of all databases
#mysqldump -h $DB_HOST --routines --single-transaction --no-create-db  > $BACKUP_FILE
# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully!"
    echo "Backup file: $BACKUP_FILE"
    
    # Compress the backup file
    gzip $BACKUP_FILE
    COMPRESSED_FILE="${BACKUP_FILE}.gz"
    echo "Backup compressed to: $COMPRESSED_FILE"

    # Upload to Azure Blob Storage
    echo "Uploading backup to Azure Blob Storage..."
    az storage blob upload \
        --connection-string "$AZURE_STORAGE_CONNECTION_STRING" \
        --container-name "$AZURE_CONTAINER_NAME" \
        --name "$(basename $COMPRESSED_FILE)" \
        --file "$COMPRESSED_FILE"

    if [ $? -eq 0 ]; then
        echo "Backup successfully uploaded to Azure Blob Storage"
        
        # Optional: Remove local backup file after successful upload
        # rm "$COMPRESSED_FILE"
        # echo "Local backup file removed"
    else
        echo "Failed to upload backup to Azure Blob Storage"
        exit 1
    fi
else
    echo "Backup failed!"
    exit 1
fi