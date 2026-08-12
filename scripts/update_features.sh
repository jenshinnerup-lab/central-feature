#!/bin/bash
#
# Weekly feature update script for Central Feature repository
# Kører scraper og opdaterer features fra Microsoft Learn
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
FEATURES_DIR="$REPO_DIR/features"
LOG_DIR="$REPO_DIR/logs"

mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/update_$(date +%Y-%m-%d).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=========================================="
log "Starting feature update"
log "=========================================="

cd "$REPO_DIR"

log "Pulling latest changes..."
git pull origin main 2>&1 | tee -a "$LOG_FILE" || log "Warning: Could not pull"

log "Running scraper..."
PYTHON_CMD="python3"
command -v python3 >/dev/null || PYTHON_CMD="python"

if ! $PYTHON_CMD -c "import requests" 2>/dev/null; then
    log "Installing requests..."
    $PYTHON_CMD -m pip install --user requests 2>&1 | tee -a "$LOG_FILE" || true
fi

$PYTHON_CMD "$SCRIPT_DIR/scrape_features.py" both 2>&1 | tee -a "$LOG_FILE"

NEW_FILES=$(git status --porcelain features/ 2>/dev/null | grep "^??" || true)

if [ -n "$NEW_FILES" ]; then
    log "New files detected:"
    echo "$NEW_FILES" | tee -a "$LOG_FILE"
    
    git add features/*.json 2>/dev/null || true
    
    if ! git diff --cached --quiet 2>/dev/null; then
        git commit -m "Update features $(date +%Y-%m-%d)

Automated update from Microsoft Learn
Languages: English, Danish" 2>&1 | tee -a "$LOG_FILE" || log "Warning: Could not commit"
        
        log "Pushing changes..."
        git push origin main 2>&1 | tee -a "$LOG_FILE" || log "Warning: Could not push"
    fi
else
    log "No new files"
fi

log "=========================================="
log "Update completed"
log "=========================================="
echo "Log: $LOG_FILE"
