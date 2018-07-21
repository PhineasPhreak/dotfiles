## Fish Shell
### Powerline Installation:
You don't have to install powerline and fonts from github to get fish with powerline.
The Ubuntu repo already has some packages. Just install them with apt.

#### Tested on Ubuntu 17.04

```bash
apt install fish powerline
```

This pulls in fonts-powerline python-powerline python-psutil python3-powerline

add the following lines to ~/.config/fish/config.fish

```
set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
source /usr/share/powerline/bindings/fish/powerline-setup.fish
powerline-setup
```

and then start a new instance of fish by typing `fish`

Presumably if you have a different set up or distro, you can use grep/find
to get the above information.

```fish
# these commands work with bash or fish
cd /
find -name fish 2>&1 | grep bindings
# which returns
./usr/share/powerline/bindings/fish
# and then
find -name '*.fish' 2>&1 | grep -e 'powerline-setup'
# returns
./usr/share/powerline/bindings/fish/powerline-setup.fish
```

![alt text](https://gist.githubusercontent.com/TrentSPalmer/63a85b582d42ab4bff665fc2dbba42e2/raw/2017-06-18-064710_722x410_scrot.png)

### Classic Installation:

PLacer le fichier "fish_prompt.fish", "fish_user_key_bindings.fish" dans:
```shell
~/.config/fish/function
```
For the file "fish_prompt.fish" copy it here:
```shell
~/etc/fish/config.fish
```

Utiliser la command suivant pour faire de Fish votre Terminal par default:
```shell
chsh -s /usr/bin/fish
```

Faire la command suivante pour reset le Terminal:
```shell
chsh -s /bin/bash
```
### Site:
Site: https://fishshell.com/

Fish GitHub: https://github.com/oh-my-fish

