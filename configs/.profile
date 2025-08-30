#!/bin/sh
#   ___  ___ ___ _  __
#  | _ \/ __| _ \ |/ /   PhineasPhreak (PSPK)
#  |  _/\__ \  _/ ' <    https://github.com/PhineasPhreak
#  |_|  |___/_| |_|\_\
#
# This file should be here ~/.profile
#
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.
#
# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Set some XDG_* variables
export XDG_SESSION_DESKTOP=i3
export XDG_CURRENT_DESKTOP=i3

# Qt theme
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_PLATFORMTHEME=qt5ct
export QT_PLATFORM_PLUGIN=qt5ct

# Qt HiDPI (https://doc.qt.io/qt-6/highdpi.html)
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1
export QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough

# GTK3 apps try to contact org.a11y.Bus. Disable that.
export NO_AT_BRIDGE=1

# Ibus settings if you need them
# type ibus-setup in terminal to change settings and start the daemon
# delete the hashtags of the next lines and restart
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=ibus
#export QT_IM_MODULE=ibus
