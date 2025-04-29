# MySQL Database Backup Script

This script automates the process of backing up MySQL databases and uploading the backups to Azure Blob Storage.

## Features

- Creates timestamped backups of MySQL databases
- Compresses backup files using gzip
- Uploads compressed backups to Azure Blob Storage
- Includes error handling and status reporting
- Supports both single database and all databases backup options

## Prerequisites

1. **MySQL Server Access**
   - MySQL server must be accessible
   - MySQL client tools installed (`mysqldump`)

2. **Azure CLI**
   - Azure CLI must be installed on the machine
   - Installation instructions:
     ```bash
     # For Ubuntu/Debian
     curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
     
     # For CentOS/RHEL
     sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
     sudo dnf install azure-cli
     
     # For macOS
     brew update && brew install azure-cli
     ```

3. **Azure Storage Account**
   - An Azure Storage Account with a container for backups
   - Storage account connection string or access key

## Setup Instructions

1. **MySQL Credentials Setup**
   Create a `.my.cnf` file in the user's home directory with MySQL credentials:
   ```bash
   [client]
   user=your_mysql_username
   password=your_mysql_password
   ```
   Set appropriate permissions:
   ```bash
   chmod 600 ~/.my.cnf
   ```

2. **Script Configuration**
   Edit the following variables in `dbbackupscript.sh`:
   ```bash
   # Database settings
   DB_HOST="your_mysql_host"
   DB_NAME="your_database_name"
   
   # Azure Storage settings
   AZURE_STORAGE_ACCOUNT="your_storage_account_name"
   AZURE_STORAGE_CONNECTION_STRING="your_storage_account_connection_string"
   AZURE_CONTAINER_NAME="your_container_name"
   ```

3. **Make Script Executable**
   ```bash
   chmod +x dbbackupscript.sh
   ```

## Usage

Run the script:
```bash
./dbbackupscript.sh
```

### Backup Options

1. **Single Database Backup** (default)
   ```bash
   mysqldump -h $DB_HOST --routines --single-transaction --no-create-db $DB_NAME > $BACKUP_FILE
   ```

2. **All Databases Backup** (uncomment to use)
   ```bash
   #mysqldump -h $DB_HOST --routines --single-transaction --no-create-db > $BACKUP_FILE
   ```

## Output

- Backup files are stored in: `/home/dgv-mvp-mysql/backups/`
- Files are named with format: `{database_name}_{timestamp}.sql.gz`
- Success/failure messages are displayed in the console

## Security Notes

- MySQL credentials are stored in `.my.cnf` with restricted permissions
- Azure storage credentials are stored in the script
- Consider using environment variables or Azure Managed Identity for production environments

## Error Handling

The script includes error handling for:
- Backup creation failures
- Compression failures
- Azure upload failures

## Maintenance

- Local backup files are retained by default
- Uncomment the cleanup section to remove local files after successful upload
- Regularly monitor Azure storage usage and costs 