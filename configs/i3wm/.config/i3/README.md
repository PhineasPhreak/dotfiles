# i3wm

## Site
One of i3’s goals is good documentation.

* [i3wm](https://i3wm.org/)
* [i3wm USERGUIDE](https://i3wm.org/docs/userguide.html)
* [i3wm VERSION REPOSITORIES](https://i3wm.org/docs/repositories.html)
* [i3wm I3STATUS DOCS](https://i3wm.org/docs/i3status.html)
* [i3wm PY3STATUS DOCS](https://i3wm.org/docs/user-contributed/py3status.html)

## Installation
In general, you should use the repositories of your distribution.
* Installation for `Debian`, `Ubuntu`
```shell
sudo apt-get update
sudo apt-get install i3 i3blocks i3status py3status i3lock suckless-tools
sudo apt-get install fonts-hack  # font used in the i3 config file
```

* For `Archlinux`
```shell
sudo pacman -S i3wm i3lock i3blocks py3status i3status dmenu
```

If you want the [latest i3 development](https://i3wm.org/docs/repositories.html) version.
If you are using Debian (Debian-derived systems might work, too) or Ubuntu and want the latest development version of i3, you should use our Debian repository.

Now importing a GPG key with `apt-key add -` **is deprecated.** Use this method instead :
```shell
curl https://baltocdn.com/i3-window-manager/signing.asc | sudo tee /etc/apt/trusted.gpg.d/signing.asc
sudo apt install apt-transport-https --yes
echo "deb https://baltocdn.com/i3-window-manager/i3/i3-autobuild-ubuntu/ all main" | sudo tee /etc/apt/sources.list.d/i3-autobuild.list
sudo apt update
sudo apt install i3
```
> For more information just see : `man apt-key`

After this Installation **Reboot** your system and changed your desktop (Gnome/KDE/XFCE -> i3)

## Customization
For a better use of i3wm, you can install other programs for a little customization :
```shell
sudo apt install nitrogen feh rofi arandr lxrandr lxterminal lxappearance # picom
```

## `Xresources` Configuration on i3wm
If you are not using a desktop environment such as KDE, Xfce, or other that manipulates the X settings for you, you can set the desired [DPI setting manually](https://wiki.archlinux.org/title/HiDPI) via the `Xft.dpi` variable in [Xresources](https://gist.github.com/PhineasPhreak/c286cc729da190bc0852c08d72158b53):
```
Xft.dpi: 80

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

## `profile` and `xinitrc` on i3wm
Depending on the type of i3 installation you are doing.
You will need to set up the [~/.profile](https://gist.github.com/PhineasPhreak/0801c2c5bac8edd47cb65232ddce1e7d) and [~/.xinitrc](https://gist.github.com/PhineasPhreak/793345f482b5642bb9b9303fccd55410) files in the user folder.
* Example with i3 installation on `ubuntu-server` without Login Manager (Display Manager)

## Configuration for `Qt`, `GTK` applications
To start with you need to install `breeze` and `qt5ct` for QT and `adwaita-icon-theme-full`, `lxappearance` for GTK :
> NOTE: qt5ct is Qt5 Configuration Utility
```shell
sudo apt-get install breeze adwaita-icon-theme-full qt5ct lxappearance
```
> NOTE PACKAGES:
> breeze: Install default theme for Qt applications
> adwaita: Install default theme for GTK applications
> qt5ct: Configuration utility for Qt applications
> lxappearance : Configuration utility for GTK applications

Once `lxappearance` and `qt5ct` are installed, set the `breeze-dark` or `breeze` theme in both applications.

And to make all `Qt` applications support this theme, you need to export some variables :
```shell
# Set some XDG_* variables
export XDG_SESSION_DESKTOP=i3
export XDG_CURRENT_DESKTOP=i3

# Qt theme
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_PLATFORMTHEME=qt5ct
export QT_PLATFORM_PLUGIN=qt5ct

# Qt HiDPI (https://doc.qt.io/qt-6/highdpi.html)
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1
export QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough

# GTK3 apps try to contact org.a11y.Bus. Disable that.
export NO_AT_BRIDGE=1
```

## i3 with Multi Monitor
By default multi monitor is 2 screen (`Center`, `Right`)

**Don't forget :**

For identifying your Display
```shell
xrandr -q | grep " connected" | cut -d ' ' -f1
```
For graphical interface of xrandr, install and use **`arandr`**
```
sudo apt-get update
sudo apt-get install arandr lxrandr  # autorandr
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
Copy few lines in `.profile` file at home directory
```
if [ $XDG_CURRENT_DESKTOP="i3" ]; then
  export XDG_CURRENT_DESKTOP=GNOME
fi
```
After this correction **Reboot** your system
> *Test on:* Ubuntu 20.04.6 LTS

## Others Settings for i3
HiDPI : https://wiki.archlinux.org/title/HiDPI \
i3wm-configuration : https://github.com/vincentbernat/i3wm-configuration/tree/master/dotfiles \
Online Colorscheme Configurator for i3, i3status, dmenu : https://thomashunter.name/i3-configurator/

