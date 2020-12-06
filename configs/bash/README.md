# Images bash with 'prompt.bash' and 'powerline.bash' on Ubuntu
![Bash-ubuntu-with-bashrc](https://github.com/PhineasPhreak/dotfiles/blob/master/screenshots/bash-ubuntu.png)
![Powerline-ubuntu-with-bashrc](https://github.com/PhineasPhreak/dotfiles/blob/master/screenshots/powerline-ubuntu.png)

> *Image Terminal Ubuntu:*

## Aliases in Terminal 
Copy this to `~/.bash_aliases` </br>
Add Aliases definition to `.bashrc`
```bash
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```

## Configure `.bashrc`
Add the code block to your `.bashrc` file.
```bash
# Use "bashrc_config.bash" for configure powerline.bash/prompt.bash
if [ -f ~/.config/prompt/bashrc_config.bash ]; then
    source ~/.config/prompt/bashrc_config.bash
fi
```

## Prompt Installation
A fast, simple bash prompt. </br>
[Markdown for installation](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/bash/prompt.bash/)

## Git powerline bash
`powerline.bash` is a dynamic command prompt in Powerline style, for BASH. </br>
[Markdown for installation](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/bash/powerline.bash/)

## Git prompt bash
A `bash` prompt that displays information about the current git repository. In particular the branch name, difference with remote branch, number of files staged, changed, etc. </br>
[Github repositories](https://github.com/magicmonty/bash-git-prompt)

## Color in Terminal
Color numbers 0–255 for terminal emulators compatible with xterm 256 colors can be found in the [xterm-256color chart](https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg)

## History completion
You can bind the up and down arrow keys to search through Bash's history. In `~/.bashrc`
```bash
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
```

## Powerline Installation
**Documentation for Powerline : [HTML - Read The Docs](https://powerline.readthedocs.io/en/master/)** | **[PDF - Read The Docs](https://media.readthedocs.org/pdf/powerline/stable/powerline.pdf)**</br>
**Archlinux wiki : [Wiki archlinux](https://wiki.archlinux.org/index.php/Powerline)**

## Powerline Github
| Name | Link |
|:---|:---|
|Github for Powerline | [Github Powerline](https://github.com/powerline/powerline)|
|Github for Powerline-fonts | [Github Powerline-fonts](https://github.com/powerline/fonts)|
|Github for Powerline-shell | [Github Powerline-shell](https://github.com/b-ryan/powerline-shell)|
|Github for Powerline-gistatus | [Github Powerline-gitstatus](https://github.com/jaspernbrouwer/powerline-gitstatus)|

## Classic Installation
Put the file at the root of your user/root account:
* For Root : `/root/.bashrc`
* For User : `/home/user/.bashrc`
```console
pspk@kali:~# ls -lhA | grep .bashrc
-rw-r--r-- 1 pspk pspk 3.4K Oct  1 00:44 .bashrc
```
