#!/bin/bash
set -euo pipefail

SRC="root@192.168.1.1:/Backup"
MOUNT_POINT="/mnt/src-server1"
REPO="/mnt/nfs/restic-server1"
PASSFILE="/root/.restic-pass"
LOG="/var/log/restic-server1-backup.log"

export RESTIC_PASSWORD_FILE="$PASSFILE"

echo "[$(date -Is)] ===== Backup Started =====" >> "$LOG"

mkdir -p "$MOUNT_POINT"

# Mount remote /home
sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 $SRC "$MOUNT_POINT"

# Run backup
restic -r "$REPO" backup "$MOUNT_POINT" >> "$LOG" 2>&1

# Keep only last 3 snapshots
restic -r "$REPO" forget --keep-last 3 --prune >> "$LOG" 2>&1

# Unmount
umount "$MOUNT_POINT"

echo "[$(date -Is)] ===== Backup Finished =====" >> "$LOG"

