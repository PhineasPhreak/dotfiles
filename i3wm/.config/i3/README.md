## i3wm 
Installation:
```shell
$ sudo apt-get update && sudo apt-get install i3
```
After this Installation **Reboot** your system and changed your desktop (Gnome -> i3)

### Bug - gnome-control-center with i3
copy few lines in `.profile` file at root directory
```
if [ $XDG_CURRENT_DESKTOP="i3" ]; then
  export XDG_CURRENT_DESKTOP=GNOME
fi
```
After this correction **Reboot** your system
> *Test on:* Ubuntu 16.04.3 LTS

### Package Install:
feh, lxappearance, [polybar](https://www.ubuntuupdates.org/package/getdeb_apps/xenial/apps/getdeb/polybar)
```shell
$ sudo apt-get install feh
$ sudo apt-get install lxappearance
$ sudo apt-get install polybar
```

### Others Theme i3
gpix13 GitHub: https://github.com/gpix13/i3

### Site:
Link: https://i3wm.org/
