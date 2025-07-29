#!/bin/zsh

# 🔧 Correction Execution Layer – reactive actions from review insights

while true; do
  if [[ -f /tmp/.agentcy_review_score.json ]]; then
    score=$(jq -r '.score' /tmp/.agentcy_review_score.json)
    priority=$(jq -r '.priority' /tmp/.agentcy_review_score.json)

    if [[ "$score" -lt 6 ]]; then
      logger "⚠️ Agentcy score low ($score) – running fallback sequence"
      osascript -e 'display notification "System optimization needed" with title "Agentcy Alert"'
      # Example: refresh Docker, reset network, relaunch containers
      pkill Docker && open --background -a Docker
    fi

    echo "[$(date)] Score: $score | Priority: $priority" >> ~/.agentcy/logs/correction.log
  fi

  sleep 180
done
