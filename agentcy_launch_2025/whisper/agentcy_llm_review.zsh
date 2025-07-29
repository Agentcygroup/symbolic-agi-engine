#!/bin/zsh

# 🧠 LLM Runtime Scoring + Self-Review Pipeline

log_input="/tmp/.agentcy_runtime.log"
review_output="/tmp/.agentcy_review_score.json"
llm_endpoint="http://localhost:11434/api/generate"

while true; do
  tail -n 50 $log_input > /tmp/.agentcy_last.log

  json='{
    "model": "gpt-4",
    "prompt": "Review this runtime activity log for inefficiencies, errors, or optimization opportunities. Provide a score (1–10), correction suggestions, and focus improvements:\n\n'$(cat /tmp/.agentcy_last.log | sed 's/"/\\"/g')'\n\nReturn JSON format: {\"score\": INT, \"suggestions\": [\"...\"], \"priority\": \"...\"}",
    "stream": false
  }'

  echo $json | curl -s -X POST -H "Content-Type: application/json" -d @- $llm_endpoint | tee $review_output >/dev/null

  sleep 300
done
