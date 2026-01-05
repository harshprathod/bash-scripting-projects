#!/bin/bash

# -e: exit on error, -u: exit on unset variables, -o pipefail: catch errors in pipes
set -euo pipefail

# Clear screen for a clean dashboard look
clear

echo "========================================"
echo "       SYSTEM INFO DASHBOARD            "
echo "========================================"
echo "Hostname    : $(hostname)"
echo "Date        : $(date '+%Y-%m-%d %H:%M:%S')"
echo "----------------------------------------"

echo

# CPU Usage
# Using printf to ensure decimal consistency
CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\):/ {print 100 - $8}')
echo "CPU Usage   : $CPU_USAGE%"

echo
# Memory Usage
# We extract variables 
MEM_AVAIL=$(free -m | awk '/Mem:/ {print $7}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')

echo "Memory Used : ${MEM_USED} MB"
echo "Memory Avail: ${MEM_AVAIL} MB"


echo
# Disk Usage 
# df -h used for display only (not for numeric comparison)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
echo "Disk Usage  : $DISK_USAGE"

echo
# Running Processes
echo "Running Processes  : "
echo "----------------------------------------"
ps -eo user,pid,%cpu,%mem,comm --sort=-%cpu | head -10

echo
# Network Interfaces
echo "Network Interfaces"
echo "----------------------------"
ip -brief addr show | awk '{printf "  %-10s: %-10s %s\n",$1 ,$2 ,$3}'

echo "==============================================================="
