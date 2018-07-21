## Image Bash Ubuntu 16.04.3 LTS amd64
![Bash-ubuntu-with-bashrc](https://github.com/PhineasPhreak/dotfiles/blob/master/screenshots/bash-ubuntu.png)

> *Image Terminal Ubuntu:*
## Powerline Installation:
Copy this to `~/.bashrc`
```shell
# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#alias usage='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias ls="ls --color"

# Powerline
if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
    source /usr/share/powerline/bindings/bash/powerline.sh
fi
```
## Classic Installation:
Put the file at the root of your user/root account:
* For Root : `/root/.bashrc`
* For User : `/home/user/.bashrc`
```shell
pspk@kali:~# ls -lhA | grep .bashrc
-rw-r--r-- 1 pspk pspk 3.4K Oct  1 00:44 .bashrc
```
