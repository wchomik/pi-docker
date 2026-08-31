#!/bin/bash
# Install extensions from PI_EXTENSIONS env var (comma-separated)
# e.g. PI_EXTENSIONS=pi-observability,pi-web-access,pi-subagents
if [ -n "$PI_EXTENSIONS" ]; then
  IFS=',' read -ra EXTS <<< "$PI_EXTENSIONS"
  for ext in "${EXTS[@]}"; do
    ext="$(echo "$ext" | xargs)"  # trim whitespace
    [ -z "$ext" ] && continue
    pi install "$ext" 2>/dev/null
  done
fi

exec ttyd -t 'theme={"background": "black"}' -p 7681 -W tmux new -A -s webshell bash
