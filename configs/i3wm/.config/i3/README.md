# i3wm 
## Installation
In general, you should use the repositories of your distribution.
* Installation for `Debian`, `Ubuntu`
```shell
$ sudo apt-get update
$ sudo apt-get install i3 i3blocks i3status i3lock dmenu
```

* For `Archlinux`
```shell
$ sudo pacman -S i3wm i3lock i3blocks i3status dmenu
```

If you want the [latest i3 development](https://i3wm.org/docs/repositories.html) version.
If you are using Debian (Debian-derived systems might work, too) or Ubuntu and want the latest development version of i3, you should use our Debian repository.

After this Installation **Reboot** your system and changed your desktop (Gnome -> i3)

## X Resources Configuration on i3wm
If you are not using a desktop environment such as KDE, Xfce, or other that manipulates the X settings for you, you can set the desired [DPI setting manually](https://wiki.archlinux.org/title/HiDPI) via the `Xft.dpi` variable in [Xresources](https://wiki.archlinux.org/title/Xresources):
```
Xft.dpi: 96

! These might also be useful depending on your monitor and personal preference:
Xft.autohint: 0
Xft.lcdfilter: lcddefault
Xft.hintstyle: hintfull
Xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rgb
```

For `Xft.dpi`, using integer multiples of 96 usually works best, e.g. 192 for 200% scaling.

Make sure the settings are loaded properly when X starts, for instance in your `~/.xinitrc` with `xrdb -merge ~/.Xresources` (see [Xresources](https://wiki.archlinux.org/title/Xresources) for more information).

This will make the font render properly in most toolkits and applications, it will however not affect things such as icon size! Setting `Xft.dpi` at the same time as toolkit scale (e.g. `GDK_SCALE`) may cause interface elements to be much larger than intended in some programs like firefox.

## i3 with Multi Monitor
By default multi monitor is 2 screen (`Center`, `Right`)

**Don't forget :**

For identifying your Display
```shell
$ xrandr -q | grep " connected" | cut -d ' ' -f1
```
For graphical interface of xrandr, install and use **`arandr`**
```
$ sudo apt-get update
$ sudo apt-get install arandr
```
**DPI :**

The DPI value of a screen indicates how many dots per inch or pixels per inch it supports. As the resolution increases, the display density also increases. You may know what resolution your display has but you may have no idea what your screen's DPI is.

For this use option of *`xrandr`*:
```
$ xrandr --dpi 85
```

## i3 with laptop touchpad
Check out the `xinput` command. `xinput list` will give you a list of input devices; find the ID of the one which looks like a touchpad. 

Then do `xinput list-props <device id>`, which should tell you what properties you can change for the input device. 

You should find one called something like `Tapping Enabled` and a number in parens after it (in my case, it's `libinput Tapping Enabled (276)`. Finally, run `xinput set-prop <device id> <property id> 1`, and tapping should work.

To make the change permanent, find a way to run that command on startup. One way would be to add:

`exec xinput set-prop <device id> <property id> 1` to `~/.i3/config`.

For my HP Laptop the command is:

`exec xinput set-prop 11 276 1`

> PS: Use **laptop** configuration because this modification actually done.

## Disabled beep terminal and screensaver for i3
* Screensaver
Add this line to `~/.config/i3/config`

`exec_always --no-startup-id "xset s off; xset -dpms; xset s noblank"`

* Beep Terminal
Add this line to `~/.config/i3/config`

`exec_always --no-startup-id "xset b off"`

* How to change cursor speed in the Linux console?
Add this line to `~/.config/i3/config`

`exec_always --no-startup-id "xset r rate 250 75"`

## Bug - gnome-control-center with i3
copy few lines in `.profile` file at home directory
```
if [ $XDG_CURRENT_DESKTOP="i3" ]; then
  export XDG_CURRENT_DESKTOP=GNOME
fi
```
After this correction **Reboot** your system
> *Test on:* Ubuntu 16.04.3 LTS

## Package Install:
feh, lxappearance, [polybar](https://www.ubuntuupdates.org/package/getdeb_apps/xenial/apps/getdeb/polybar)
```shell
$ sudo apt-get install feh polybar lxappearance
```

## Others Settings for i3
HiDPI : https://wiki.archlinux.org/title/HiDPI
gpix13 GitHub: https://github.com/gpix13/i3
Online Colorscheme Configurator for i3, i3status, dmenu : https://thomashunter.name/i3-configurator/

## Site:
Link: https://i3wm.org/
