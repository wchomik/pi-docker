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

# Configurable via TTYD_PORT and TTYD_THEME environment variables
TTYD_PORT="${TTYD_PORT:-7681}"
TTYD_THEME="${TTYD_THEME:-theme={"background": "black"}}"

exec ttyd -t "$TTYD_THEME" -p "$TTYD_PORT" -W tmux new -A -s webshell bash
