# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

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

# open files with default application
alias open='xdg-open'

# alias for 'sudo' in 'sd'
alias sd='sudo'

# alias 'clear' in 'cl'
alias cl='clear'

# quick switch to directories
alias cddown='cd ~/Downloads/'
alias cddoc='cd ~/Documents/'
alias cdpic='cd ~/Pictures/'
alias cdgit='cd ~/Git/'
alias cdlab='cd ~/Lab/'

alias ..='cd ..'
alias ...='cd ../..'

# prompt before overwrite with option "-i" for "cp", "mv' and "rm"
#alias cp='cp -v'
#alias mv='mv -v'
#alias rm='rm -v'

# shortcut command 'df'
alias df='df -Th'

# Summarize disk usage of the set of FILEs, recursively for directories
alias du='du -h'

# show free space memory
alias free='free -ht'

# show command "jobs" in list format
alias jobs='jobs -l'

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
#alias sources='cat -n /etc/apt/sources.list && ls -lhA /etc/apt/sources.list.d/'

# some more ls aliases
alias lda='ls --color=auto -lhAF --group-directories-first'
alias ld='ls --color=auto -lhF --group-directories-first'
alias ll='ls -lhF'
alias la='ls -lhAF'
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

# command watch with interpret ANSI color
alias watch='watch --color'

# some more reboot and poweroff for KALI LINUX
#alias reboot='sudo reboot'
#alias poweroff='sudo poweroff'

# History completion
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
