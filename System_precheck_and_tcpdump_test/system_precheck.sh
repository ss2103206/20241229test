#!/bin/bash

# 定義日誌檔案
LOG_FILE="/tmp/system_precheck.log"
echo "System Precheck Log - $(date)" > $LOG_FILE

# 函數：記錄日誌
log() {
  echo "$1" | tee -a $LOG_FILE
}

# 函數：檢查命令是否存在
check_command() {
  command -v $1 >/dev/null 2>&1 || { log "ERROR: Command $1 not found."; exit 1; }
}

# 函數：檢查磁碟使用率
check_disk_usage() {
  log "\nStep Checking disk usage..."
  # 搜尋使用率超過 75% 的分區
  result=$(df -h | grep -e "7[5-9]%" -e "[8-9][0-9]%" -e "100%")
  
  if [ -n "$result" ]; then
    log "Disk usage alert:\n$result"
    # 在此處整合發送郵件的指令，例如 `mail` 或其他通知工具
    echo -e "Disk usage alert:\n\n$result" | mail -s "Disk Usage Alert" your_email@example.com
    log "Disk usage email notification sent!"
  else
    log "Disk usage is normal."
  fi
}

# Precheck 開始
log "Starting system precheck..."

# 1. 檢查系統版本
log "\n[Step 1] Checking system version..."
cat /etc/os-release | tee -a $LOG_FILE

# 2. 檢查 CPU 和記憶體狀況
log "\n[Step 2] Checking CPU and memory usage..."
log "CPU Info:"
lscpu | grep "Model name" | tee -a $LOG_FILE
log "Memory Info:"
free -h | tee -a $LOG_FILE

# 3. 檢查系統服務
log "\n[Step 3] Checking critical system services..."
SERVICES=("sshd" "docker" "kubelet" "crond" "httpd")
for service in "${SERVICES[@]}"; do
  if systemctl is-active --quiet $service; then
    log "Service $service is running."
  else
    log "ERROR: Service $service is NOT running."
  fi
done

# 4. 檢查關鍵命令是否可用
log "\n[Step 4] Checking critical commands..."
CRITICAL_COMMANDS=("wget" "curl" "ping" "tar" "awk" "sed")
for cmd in "${CRITICAL_COMMANDS[@]}"; do
  check_command $cmd
  log "Command $cmd is available."
done

# 5. 檢查檔案和目錄是否存在
log "\n[Step 5] Checking required files and directories..."
FILE_1="/opt/all_scripts/check_internal_alarm/rc_list"
FILE_2="/opt/all_scripts/global/conf/NetAct_db_query_aut"
DIR_1="/opt/all_scripts/check_internal_alarm/output/"
if [ -f "$FILE_1" ] && [ -f "$FILE_2" ] && [ -d "$DIR_1" ]; then
  log "All required locations exist. Running check internal alarm..."
  /opt/all_scripts/check_internal_alarm/check_internal_alarm.py
else
  log "One or more required locations do not exist. Exiting..."
fi

# Precheck 結束
log "\nSystem precheck completed. Check log file at: $LOG_FILE"


