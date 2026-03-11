#!/bin/sh
#@author ilasie
#@since 2026

set -e

folder="$HOME/Pictures/screenshots"
file="$folder/$(date +%Y%m%d%H%M%S).png"

/bin/scrot $* "$file"
/bin/dunstify -t 2000 -u normal "Screen Shots" "Saved to $file"
