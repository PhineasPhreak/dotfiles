#   ___  ___ ___ _  __
#  | _ \/ __| _ \ |/ /   PhineasPhreak (PSPK)
#  |  _/\__ \  _/ ' <    https://github.com/PhineasPhreak
#  |_|  |___/_| |_|\_\
#
# This file should be here ~/.bash_aliases
#
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
#

### EXPORT (It designates specified variables and functions to be passed to child processes.)
# $EDITOR use Emacs in terminal
export EDITOR="emacsclient -t -a ''"
# $VISUAL use Emacs in GUI mode
export VISUAL="emacsclient -c -a emacs"
# removal of expressions from the history command.
export HISTIGNORE="history*:ls*:cd*:pwd:exit:clear:sudo reboot:sudo poweroff"

### SHOPT (This builtin allows you to change additional optional shell behavior.)
shopt -s autocd            # change to named directory
shopt -s cdspell           # autocorrects cd misspellings
shopt -s cmdhist           # save multi-line commands in history as single line
shopt -s dotglob           # bash includes filenames beginning with a '.' in the results of filename expansion
shopt -s histappend        # do not overwrite history
shopt -s expand_aliases    # expand aliases

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# History completion
# Just edit your ~/.inputrc (you might need to create one or copy the one in /etc/inputrc there)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\C-H": shell-backward-kill-word' # CTRL+Backspace

# ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

### FUNCTION
# extr = EXTRactor for all kinds of archives
# usage: ex <file>
function ex {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: ex: <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
              *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                  tar xvf "$n"       ;;
              *.lzma)      unlzma ./"$n"      ;;
              *.bz2)       bunzip2 ./"$n"     ;;
              *.cbr|*.rar)       unrar x -ad ./"$n" ;;
              *.gz)        gunzip ./"$n"      ;;
              *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
              *.z)         uncompress ./"$n"  ;;
              *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                  7z x ./"$n"        ;;
              *.xz)        unxz ./"$n"        ;;
              *.exe)       cabextract ./"$n"  ;;
              *.cpio)      cpio -id < ./"$n"  ;;
              *.cba|*.ace)      unace x ./"$n"      ;;
              *)
                  echo "ex: '$n' - unknown archive method"
                  return 1
                  ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

# Show a directory listing when using 'cd'
function cdls() {
    new_directory="$*";
    if [ $# -eq 0 ]; then
        new_directory=${HOME};
    fi;
    builtin cd "${new_directory}" && /bin/ls -lhF --color=auto --time-style=long-iso --ignore=lost+found
}

### ALIASES (allows users to create shortcuts for frequently used commands, enhancing workflow efficiency)
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    #alias lls='ls --color=auto -lhF'
    #alias lss='ls --color=auto -lhFA --group-directories-first'
    alias diff='diff --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias ip='ip --color=auto'
fi

# command watch with interpret ANSI color
alias watch='watch --color'

# some more ls aliases
alias lda='ls --color=auto -lhAF --group-directories-first'
alias ld='ls --color=auto -lhF --group-directories-first'
alias ll='ls --color=auto -lhF'
alias la='ls --color=auto -lhAF'
alias lf='ls --color=auto -lhAF'
alias l='ls --color=auto -CF'

# get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# systemctl info
alias sysfailed="systemctl list-units --failed"

# open files with default application
alias open='xdg-open'

# alias for 'sudo' in 'sd'
alias sd='sudo'

# alias 'clear' in 'cl'
alias cl='clear'

# quick switch to directories
# alias cddown='cd ~/Downloads/'
# alias cddoc='cd ~/Documents/'
# alias cdpic='cd ~/Pictures/'
# alias cdgit='cd ~/Git/'
# alias cdlab='cd ~/Lab/'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# prompt before overwrite with option "-i" for "cp", "mv' and "rm"
#alias cp='cp -v'
#alias mv='mv -v'
#alias rm='rm -v'

# df human-readable sizes
alias df='df -Th'

# Summarize disk usage of the set of FILEs, recursively for directories
alias du='du -h'

# show free space memory total+human-readable sizes
alias free='free -ht'

# ps
alias psa='ps auxf'

# show command "jobs" in list format
alias jobs='jobs -l'

# launch emacs in terminal
alias temacs='emacs -nw'

# merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# shorcut 'apt' or 'apt-get'
alias update='sudo apt-get update'
alias install-package='sudo apt-get install $argv'
alias search-package='sudo apt-cache search $argv'
alias show-package='sudo apt-cache show $argv'
alias get-upgrade='sudo apt-get upgrade'
alias apt-upgrade='sudo apt upgrade'
alias full-upgrade='sudo apt full-upgrade'
alias dist-upgrade='sudo apt-get dist-upgrade'
alias list-upgradable='sudo apt list --upgradable'
alias autoremove='sudo apt-get autoremove'
alias cleanliness='sudo apt-get clean'
alias cache-policy='sudo apt-cache policy'
alias list-key='sudo apt-key list'

# alias "screen" for SSH session
alias sc='screen'
alias scls='screen -ls'
alias scs='screen -S'
alias scr='screen -r'
alias scx='screen -x'
alias scd='screen -d'

# mark show hold packages
alias mark-show-hold='sudo apt-mark showhold'

# some more reboot and poweroff for KALI LINUX
#alias sreboot='systemctl reboot'
#alias spoweroff='systemctl poweroff'

# Add aliases for certain virtualbox commands
alias vmlist='vboxmanage list vms'
alias vmrunning='vboxmanage list runningvms'
alias vmshowvminfo='vboxmanage showvminfo $1'
alias vmstart='vboxmanage startvm $1'
alias vmstarthl='vboxmanage startvm $1 --type headless'

# NVIDIA GPU (For Nvidia GPU for specific process)
alias nvidia-run="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia $argv"
