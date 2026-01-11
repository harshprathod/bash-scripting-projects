#!/bin/bash
set -euo pipefail

# Log if anything fails
trap 'log "ERROR: Backup failed at the line $LINENO"' ERR	

# Load configuration
CONFIG_FILE="./backup_config.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi

source "$CONFIG_FILE"

LOG_FILE="${BACKUP_DIR}/backup.log"

log(){
	echo "$(date '+%Y-%m-%d_%H-%M%-S')" $1 | tee -a "$LOG_FILE"
}

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="backup_${TIMESTAMP}.tar.gz"
DESTINATION="${BACKUP_DIR}/${BACKUP_FILE}"

log "Backup Started..."
echo "Source directories: ${SOURCE_DIRS}"
echo "Backup destination: ${DESTINATION}"

mkdir -p "$BACKUP_DIR"
tar -czf "$DESTINATION" $SOURCE_DIRS

log "Backup Successfully completed..."

log "Removing backups older than ${RETENTION_DAYS} days..."

find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete

log "Old backups cleaned up"

