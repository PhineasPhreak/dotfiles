# rofi
Rofi is a window switcher, run dialog, ssh-launcher

* Wiki rofi : [Welcome to the rofi wiki!](https://github.com/davatorium/rofi/wiki)

* archlinux wiki : [rofi archlinux wiki](https://wiki.archlinux.org/title/Rofi)

* Rofi theme generator : [rofi theme generator](https://comfoxx.github.io/rofi-old-generator/p11-Generator.html)

## Installation
Update your Repositories and install `rofi`:

For Debian or Ubuntu distribution:
```shell
$ sudo apt-get update
$ sudo apt-get install rofi
```

For Archlinux:
```shell
$ pacman -Sy
$ sudo pacman -S rofi
```

## Configuration Rofi
For all themes, checking themes in: `/usr/share/rofi/themes`

Paste the `config` file to the home directory
```shell
~/.config/rofi/config
```

## Shorcut
Use the following command to lauch rofi:

* Custom themes
```shell
rofi -show run -theme ~/.config/rofi/dark-blue.rasi -font "Hack 10" -display-run "Cmd"
```


* Default themes in `/usr/share/rofi/themes`
```shell
rofi -show run -theme Arc-Dark -font "Hack 10" -display-run "Cmd"
```
For window:
```shell
rofi -show window -theme Arc-Dark -font "Hack Bold 10" -display-window "Window"
```
