## i3wm 
Installation:
```shell
$ sudo apt-get update && sudo apt-get install i3
```
After this Installation **Reboot** your system and changed your desktop (Gnome -> i3)

### i3 with Multi Monitor
For multi monitor use multi-monitor config
* By default multi monitor is 2 screen (Center, Right)

**Don't forget:**

For identifying your Display
```shell
$ xrandr -q | grep " connected" | cut -d ' ' -f1
```
### i3 with laptop touchpad
Check out the `xinput` command. `xinput list` will give you a list of input devices; find the ID of the one which looks like a touchpad. Then do `xinput list-props <device id>`, which should tell you what properties you can change for the input device. You should find one called something like `Tapping Enabled` and a number in parens after it (in my case, it's `libinput Tapping Enabled (276)`. Finally, run `xinput set-prop <device id> <property id> 1`, and tapping should work.

To make the change permanent, find a way to run that command on startup. One way would be to add:

`exec xinput set-prop <device id> <property id> 1` to `~/.i3/config`.

For my HP Laptop the command is:

`exec xinput set-prop 11 276 1`

### Disabled beep terminal and screensaver for i3
* Screensaver
Add this line to `~/.config/i3/config`

`exec_always --no-startup-id "xset s off; xset -dpms; xset s noblank"`

* Beep Terminal
Add this line to `~/.config/i3/config`

`exec_always --no-startup-id "xset b off"`

### Bug - gnome-control-center with i3
copy few lines in `.profile` file at home directory
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
