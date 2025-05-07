#!/bin/bash

# Check if backup2gh is running
if ! pgrep -f "backup2gh" > /dev/null; then
  echo "[$(date)] backup2gh not running, restarting..."
  /app/configure.sh --backup-only
else
  echo "[$(date)] backup2gh is running."
fi