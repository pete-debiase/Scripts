#!/usr/bin/env bash
# Manage Anki and mplayer windows to facilitate SUBS2SRS practice.
# Peter Adriano DeBiase 2018/09/27

# set -o errexit
# set -o pipefail

echo Starting Anki Practice Assistant...
echo Press R to resize or Q to exit.

anki &

while true; do
  active_window=$(xdotool getactivewindow getwindowname)

  if [[ $active_window = "MPlayer" ]]; then
    # echo Anki
    wmctrl -a Anki
  fi

  # In the following line -t for timeout, -N for just 1 character
  read -t 0.25 -N 1 input
  if [[ $input = "r" ]] || [[ $input = "R" ]]; then
    i3-msg resize shrink width 480
  elif [[ $input = "q" ]] || [[ $input = "Q" ]]; then
    clear
    break
  fi

  sleep 2
done

echo syncing to Google Drive...
rclone sync "/home/pete/.local/share/Anki2" "GoogleDrive:/Backups/TPYm/home/pete/.local/share/Anki2" --config="/home/pete/.config/rclone/rclone.conf" -v -L

if [[ $HOSTNAME = "TPYm" ]]; then
  echo done. suspending in 60 seconds...
  sleep 60
  systemctl suspend
fi
