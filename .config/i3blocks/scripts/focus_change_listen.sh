#!/bin/bash
# executed by i3 >= 4.18
#   to listen focus change
#   to display window title (in ./window_title)
/bin/i3-msg -m -t subscribe '["window"]' | \
while IFS= read -r event; do
  if printf '%s' "$event" | grep -q '"change":"focus"'; then
    pkill -RTMIN+10 i3blocks 2>/dev/null
  fi
done
