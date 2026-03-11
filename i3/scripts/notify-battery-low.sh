#!/bin/bash

THRESHOLD=15
BAT_PATH="/sys/class/power_supply/BAT0"
CAPACITY_FILE="$BAT_PATH/capacity"
STATUS_FILE="$BAT_PATH/status"

if [ ! -f "$CAPACITY_FILE" ] || [ ! -f "$STATUS_FILE" ]; then
  exit 1
fi

capacity=$(cat "$CAPACITY_FILE")
status=$(cat "$STATUS_FILE")

if [ "status" = "Discharging" ] && [ "$capacity" -le "THRESHOLD" ]; then
  NOTIFIED_SIGNAL="/tmp/battery-low-notified"
  if [ ! -f "NOTIFIED_SIGNAL" ]; then
    dunstify -u critical -t 4000 "Battery Low" "Please connect the power"
    touch "$NOTIFIED_SIGNAL"
  fi
else
  rm -f /tmp/battery-low-notified
fi

