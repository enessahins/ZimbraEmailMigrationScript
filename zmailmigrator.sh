#!/bin/bash

# Define variables
# Make sure to change the remote server information
BACKUP_DIR="/opt/backups"                  # Backup directory
REMOTE_SERVER="111.222.333.444"            # Remote server IP address
REMOTE_PORT="22"                           # Remote server port
REMOTE_USER="root"                         # Remote server username
REMOTE_PASS="SSHpassword"                  # Remote server password
ZIMBRA_BIN="/opt/zimbra/bin"               # Zimbra bin file path

EMAILS_FILE="$BACKUP_DIR/emails.txt"       # File containing email addresses

# Retrieve email addresses from the remote server
sshpass -p "$REMOTE_PASS" rsync -avzh -e "ssh -p $REMOTE_PORT" "$REMOTE_USER"@$REMOTE_SERVER:$EMAILS_FILE $BACKUP_DIR


# Step 3: Process emails on the local server
for email in $(cat $EMAILS_FILE); do

  # Backup each email
  sshpass -p "$REMOTE_PASS" ssh -p "$REMOTE_PORT" "$REMOTE_USER"@$REMOTE_SERVER "$ZIMBRA_BIN/zmmailbox -z -m $email getRestURL \"/?fmt=tgz\" > $BACKUP_DIR/$email.tgz"

  # Download the backup file from the remote server
  sshpass -p "$REMOTE_PASS" rsync -avzh -e "ssh -p $REMOTE_PORT" "$REMOTE_USER"@$REMOTE_SERVER:$BACKUP_DIR /opt/

  ## Restore the backup file and upload it to the target server
  $ZIMBRA_BIN/zmmailbox -z -m "$email" -t 0 postRestURL "/?fmt=tgz&resolve=skip" "$BACKUP_DIR/$email.tgz"

  ## Clean up the backup file
  sshpass -p "$REMOTE_PASS" ssh -p "$REMOTE_PORT" "$REMOTE_USER"@$REMOTE_SERVER "rm '$BACKUP_DIR/$email.tgz'"

  ## Display completion message for each email
  echo "$email -- finished"
done
