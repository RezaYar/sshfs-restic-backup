# SSHFS + Restic Remote Backup Automation

A lightweight and automated backup solution for legacy Linux servers using **SSHFS** and **Restic**.

This project was designed to migrate and back up data from a legacy **CentOS 7** server to a new **AlmaLinux** server without installing any backup agent on the source system.

It supports fully automated backups using SSH key authentication and can be scheduled via cron.

---

## 🚀 Features

- Remote directory mounting via SSHFS
- Incremental and deduplicated backups using Restic
- No backup agent required on the source server
- SSH key-based authentication (no password required)
- Automatic snapshot retention (keep last N backups)
- Logging support for monitoring and debugging
- Suitable for legacy or restricted environments
- Simple shell-based implementation (no complex dependencies)

---

## 🧱 Architecture

```
Source Server (CentOS 7)
        │
        │ SSHFS (SSH Key Auth)
        ▼
Mount Point on Backup Server (AlmaLinux)
        │
        │ Restic Backup
        ▼
Backup Repository (Local/NFS/External Storage)
```

---

## 📦 Requirements

On the backup server (AlmaLinux):

- `restic`
- `sshfs`
- `openssh-client`
- `fuse`
- `ssh key authentication configured`

Install dependencies:

```bash
dnf install -y restic sshfs fuse
```

---

## 🔐 SSH Key Strategy

This project uses ED25519 SSH keys for secure and efficient authentication.

Keys are generated per-server to isolate access:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/server1
```

### Copy key to source server:

```bash
ssh-copy-id root@192.168.1.1
```

After this setup, no password is required for SSH access.

---

## ⚙️ Configuration

Edit variables in `backup.sh`:

```bash
SRC="root@192.168.1.1:/Backup"
MOUNT_POINT="/mnt/src-server1"
REPO="/mnt/nfs/restic-server1"
PASSFILE="/root/.restic-pass"
LOG="/var/log/restic-server1-backup.log"
```

### Parameters:

| Variable | Description |
|----------|-------------|
| `SRC` | Remote server path (SSHFS source) |
| `MOUNT_POINT` | Local mount directory |
| `REPO` | Restic backup repository |
| `PASSFILE` | Restic password file |
| `LOG` | Log file path |

---

## 🛠️ Usage

### 1. Initialize Restic repository (first time only):

```bash
restic init -r /mnt/nfs/restic-server1
```

---

### 2. Run backup manually:

```bash
chmod +x backup.sh
./backup.sh
```

---

### 3. Add to cron (automation):

```bash
crontab -e
```

Example (daily at 2 AM):

```cron
0 2 * * * /root/backup.sh
```

---

## 🧾 Logging

All backup operations are logged:

```bash
/var/log/restic-server1-backup.log
```

Example log output:

```
2026-05-23T02:00:01+00:00 ===== Backup Started =====
2026-05-23T02:10:15+00:00 ===== Backup Finished =====
```

---

## 🧹 Retention Policy

The script keeps only the latest 3 snapshots:

```bash
restic forget --keep-last 3 --prune
```

You can adjust this value based on storage policy.

---

## 🔒 Security Notes

- Uses SSH key-based authentication (no passwords)
- No credentials stored in plaintext
- Suitable for automated cron execution
- Can be modified to use non-root SSH users for better security

---

## ⚠️ Important Notes

- Ensure SSH connectivity before running the script
- Mount point must have sufficient permissions
- Restic repository must be initialized before first run
- SSHFS requires FUSE support on Linux

---

## 📈 Possible Improvements

- Add email/Telegram notifications
- Add configuration file (YAML/JSON support)
- Add retry mechanism for network failures
- Add systemd service instead of cron
- Add multiple source server support
- Add compression and bandwidth control options

---

## 🧑‍💻 Author Notes

This project was built as a real-world solution for migrating data from a legacy CentOS 7 environment to AlmaLinux while dealing with:

- Limited disk space
- No ability to install agents on source system
- Need for automated and incremental backups

---

## 📜 License

MIT License
