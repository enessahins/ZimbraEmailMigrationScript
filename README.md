# Zimbra Email Migration Script

This script facilitates the backup and migration of Zimbra email accounts from one Zimbra server to another. The process involves:

1. Backing up emails from a source server.
2. Transferring those backups to the local server.
3. Restoring the emails to the target Zimbra server.
4. Cleaning up backup files.

It uses `rsync` and `sshpass` to handle file transfers and `zmmailbox` for interacting with Zimbra servers.

## Features

- **Email Backup**: Backs up email accounts in `.tgz` format.
- **Backup Transfer**: Uses `rsync` to transfer backup files between servers.
- **Email Restoration**: Restores emails to the target Zimbra server using `zmmailbox`.
- **Automated Cleanup**: Automatically deletes backup files after restoration.

## Prerequisites

- **Zimbra Server Access**: Ensure you have root access to both source and target Zimbra servers.
- **Installed Tools**:
  - `sshpass`: For automating SSH password entry.
  - `rsync`: For transferring files between servers.
  - `zmmailbox`: Zimbra's command-line utility to manage mailboxes.
  
- **Server Configuration**:
  - The source Zimbra server should be accessible via SSH.
  - The target Zimbra server should have the same Zimbra version to ensure compatibility with the restore process.

## Usage

### Step 1: Define Variables

Before running the script, modify the variables in the script according to your environment:

```bash
BACKUP_DIR="/opt/backups"              # Local directory for backups
REMOTE_SERVER="111.222.333.444"        # IP of the source server
REMOTE_PORT="22"                       # SSH port of the source server
REMOTE_USER="root"                     # SSH user for the source server
REMOTE_PASS="SSHpassowrd"              # SSH password for the source server
ZIMBRA_BIN="/opt/zimbra/bin"           # Path to Zimbra's bin directory
```
- **BACKUP_DIR**: Directory to store backup files locally.
- **REMOTE_SERVER**: The source Zimbra server's IP address.
- **REMOTE_PORT**: The SSH port on the source server (default is `22`).
- **REMOTE_USER**: The SSH username with access to the source server.
- **REMOTE_PASS**: The SSH password for the above user.
- **ZIMBRA_BIN**: The location of the Zimbra `zmmailbox` binary on the server.

### Step 2: Prepare the `emails.txt` File

The script requires a list of email addresses to migrate. You can generate the list on the source server or manually create it and store it in a file called `emails.txt` inside the backup directory.

### Step 3: Run the Script

Run the script by executing:

```bash
bash zimbra_email_migration.sh
```
### Step 4: Script Execution

The script performs the following steps for each email in the `emails.txt` file:

1. **Backup Emails**: The script uses `zmmailbox` to export emails to a `.tgz` backup file.
2. **Transfer Backup**: The backup file is transferred to the local backup directory using `rsync`.
3. **Restore Emails**: The script restores the backup to the target Zimbra server using `zmmailbox`.
4. **Cleanup**: After restoration, the backup files are deleted from the source server.

### Step 5: Verify Migration

After the script completes, verify that the email accounts have been migrated successfully to the target server by checking the target Zimbra mailboxes.


