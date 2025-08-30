#!/bin/sh
#   ___  ___ ___ _  __
#  | _ \/ __| _ \ |/ /   PhineasPhreak (PSPK)
#  |  _/\__ \  _/ ' <    https://github.com/PhineasPhreak
#  |_|  |___/_| |_|\_\
#
# This file should be here ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Make sure the settings are loaded properly when X starts
xrdb -merge ~/.Xresources &

# Start i3wm
exec i3
