# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
   if [ "$USERNAME" = root ]; then
      PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\[\033[01;35m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
   else
      # Color for Kali Linux
      #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u@\[\033[01;35m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\033[01;35m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\033[01;31m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
   fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

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
fi
# alias 'clear' in 'cl'
alias cl='clear'

# quick switch to directories
alias cddown='~/Downloads'
alias cddoc='~/Documents'
alias cdgit='~/Git'
alias cdlab='~/Lab'
alias cdos='~/OS'

# prompt before overwrite for "cp", "mv' and "rm"
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# shortcut command 'df'
alias df='df -Th'

# Summarize disk usage of the set of FILEs, recursively for directories
alias du='du -h'

# show free space memory
alias free='free -ht'

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
alias sources='cat -n /etc/apt/sources.list && ls -lhA /etc/apt/sources.list.d/'

# some more ls aliases
alias ll='ls -l'
alias la='ls -lhA'
alias lf='ls -lhAF'
alias l='ls -CF'

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
#alias reboot='sudo reboot'
#alias poweroff='sudo poweroff'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
