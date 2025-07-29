#!/bin/zsh

# 🚨 LIVE AI WATCHDOG — full self-optimizing control loop

logfile="/tmp/.agentcy_runtime.log"
mkdir -p ~/.agentcy/logs

while true; do
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # 1. 📊 Learn Your Patterns
  apps=$(osascript -e 'tell application "System Events" to get name of (processes where background only is false)')
  echo "[$timestamp] Active apps: $apps" >> $logfile

  # 2. 🛡️ Prevent Mistakes
  idle=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')
  if [[ "$idle" -gt 180 ]]; then
    osascript -e 'display notification "You’ve been idle for 3+ min" with title "Agentcy Reminder"'
  fi

  # 3. 🧠 Auto-Correct
  recent=$(ls -lt ~/Documents | head -2 | tail -1 | awk '{print $9}')
  [[ -z "$recent" ]] || echo "Last file touched: $recent" >> $logfile

  # 4. 🔄 Sync Git + GCP
  cd ~/agentcy_launch_2025 > /dev/null
  git diff --quiet || (git add . && git commit -m "auto-sync @ $timestamp" && git push origin main)
  gsutil -m rsync -r ~/agentcy_launch_2025 gs://thread-lace-llc/agentcy_backup >/dev/null 2>&1

  # 5. 🧭 Silent Mentorship (TTS optional)
  if [[ $(date +%M) == "00" ]]; then
    echo "[$timestamp] Hour mark: log checkpoint" >> ~/.agentcy/logs/hourly.log
  fi

  sleep 60
done
