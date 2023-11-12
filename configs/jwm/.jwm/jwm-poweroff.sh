#!/bin/bash
# Original file location : /usr/libexec/jwm/jwm-poweroff.sh
#
#       Copyright (C) 2007-2008 Jari Aalto
#       Copyright (C) 2015  Israel Dahl
#
#   Modification to use dbus or systemd commands or fallback to Terminal
#   Also added zenity/gxmessage/xmessage alternatives if they exist
#
#   License
#
#       This program is free software; you can redistribute it and/or
#       modify it under the terms of the GNU General Public License as
#       published by the Free Software Foundation; either version 2 of
#       the License, or (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful, but
#       WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#       General Public License for more details.
#
if [ ! -z "$(which systemctl)" ]
then
SHUTDOWN="systemctl poweroff"
else
  if [ ! -z "$(which dbus-send)" ]
  then
    SHUTDOWN="dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop"
  else
    SHUTDOWN="/bin/sh -c '/bin/echo give root password for POWEROFF or press C-d to exit; /bin/su -c /sbin/poweroff'"
  fi
fi

if [ ! -z "$(which zenity)" ]
then
zenity --question --title="Shutdown" --text="Shutdown?"
  case $? in
     0) echo "Shutdown"
     ${SHUTDOWN}
       ;;
     1) exit 1;;
    -1) exit 2;;
    esac
else
  if [ ! -z "$(which gxmessage)" ]
  then
    MESSAGE="$(which gxmessage) -borderless"
  else
    if [ ! -z "$(which xmessage)" ]
    then
      MESSAGE=xmessage
    else
      x-terminal-emulator \
    -name Poweroff \
    -title Poweroff \
    -e "${SHUTDOWN}"
     fi ## XMESSAGE
  fi ## GXMESSAGE

  $MESSAGE -nearmouse -buttons "Yes:3,No:4" -name "Restart" "Shutdown?"
  case $? in

  3) echo "Shutdown"
     ${SHUTDOWN}
  ;;

  *)  echo "abort Shutdown"
  ;;

 esac

fi ## zenity
