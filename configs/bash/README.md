## Image Bash Ubuntu *16.04.3 LTS amd64* and *18.04.1 LTS amd64*
![Bash-ubuntu-with-bashrc](https://github.com/PhineasPhreak/dotfiles/blob/master/screenshots/bash-ubuntu.png)
![Powerline-ubuntu-with-bashrc](https://github.com/PhineasPhreak/dotfiles/blob/master/screenshots/powerline-ubuntu.png)

> *Image Terminal Ubuntu:*

## Aliases in Terminal :
Copy this to `~/.bash_aliases` </br>
**Add Aliases definition to `.bashrc`**
```shell
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```

## Powerline Installation :
**Documentation for Powerline : [HTML - Read The Docs](https://powerline.readthedocs.io/en/master/)** | **[PDF - Read The Docs](https://media.readthedocs.org/pdf/powerline/stable/powerline.pdf)**</br>
**Archlinux wiki : [Wiki archlinux](https://wiki.archlinux.org/index.php/Powerline)**

### Powerline Github :
| Name | Link |
|:---|:---|
|Github for Powerline | [Github Powerline](https://github.com/powerline/powerline)|
|Github for Powerline-fonts | [Github Powerline-fonts](https://github.com/powerline/fonts)|
|Github for Powerline-shell | [Github Powerline-shell](https://github.com/b-ryan/powerline-shell)|
|Github for Powerline-gistatus | [Github Powerline-gitstatus](https://github.com/jaspernbrouwer/powerline-gitstatus)|
</br>

Copy this to `~/.bashrc`
```shell
# Use Powerline
if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source /usr/share/powerline/bindings/bash/powerline.sh
fi
```
## Classic Installation :
Put the file at the root of your user/root account:
* For Root : `/root/.bashrc`
* For User : `/home/user/.bashrc`
```shell
pspk@kali:~# ls -lhA | grep .bashrc
-rw-r--r-- 1 pspk pspk 3.4K Oct  1 00:44 .bashrc
```
