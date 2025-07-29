#!/bin/zsh

# Passive voice listener that triggers Whisper only when wake word is heard
python3 ~/agentcy_launch_2025/whisper/listen_for_trigger.py | while read -r line; do
  if [[ "$line" == *"agentcy"* ]]; then
    nohup python3 ~/agentcy_launch_2025/whisper/voice_trigger.py >/dev/null 2>&1 &
  fi
done
