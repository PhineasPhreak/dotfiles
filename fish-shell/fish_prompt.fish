function fish_prompt
	if not set -q VIRTUAL_ENV_DISABLE_PROMPT
        set -g VIRTUAL_ENV_DISABLE_PROMPT true
    end
    set_color -o red #yellow
    printf '%s' (whoami)
#   set_color purple #normal
    printf '@'
#   printf '❙'

#   set_color -o red #magenta
    echo -n (prompt_hostname)
    set_color normal
    printf ':'

    set_color -o blue #$fish_color_cwd
    printf '%s' (echo $PWD | sed -e "s|^$HOME|~|")
    set_color normal

    # Line 2
#   echo
    if test $VIRTUAL_ENV
        printf "(%s) " (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
    end
#   printf ' ↪ '
#   printf '❱ '
    printf '# '
    set_color normal
end

alias cl='clear'
alias ls='ls --color=auto'
#alias ll='ls -lhF'
#alias la='ls -lhAF'
#alias l='ls -CF'

alias dir='dir --color=auto'
alias diff='diff --color=auto'
#alias vdir='vdir --color=auto'
alias grep='grep --color=auto'


