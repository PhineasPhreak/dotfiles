## Image Bash Ubuntu 16.04.3 LTS amd64
![Bash-ubuntu-with-bashrc](https://github.com/PhineasPhreak/dotfiles/blob/master/screenshots/bash-ubuntu.png)
![Powerline-ubuntu-with-bashrc](https://github.com/PhineasPhreak/dotfiles/blob/master/screenshots/powerline-ubuntu.png)

> *Image Terminal Ubuntu:*
## Powerline Installation:
**Documentation for Powerline : [Read The Docs](https://powerline.readthedocs.io/en/master/)**</br>
**Github for Powerline : [Github here](https://github.com/powerline/powerline)**</br>
**Archlinux wiki : [Wiki archlinux](https://wiki.archlinux.org/index.php/Powerline)**

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
## Classic Installation:
Put the file at the root of your user/root account:
* For Root : `/root/.bashrc`
* For User : `/home/user/.bashrc`
```shell
pspk@kali:~# ls -lhA | grep .bashrc
-rw-r--r-- 1 pspk pspk 3.4K Oct  1 00:44 .bashrc
```
