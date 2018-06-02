## URxvt-Unicode

### Important:
Copy file and rename **`Xdefaults`** to **`~/.Xdefaults`**

### If you use VIM with colorscheme install rxvt-unicode-256color
```shell
$ sudo apt-get install rxvt-unicode-256color
```
And test your session urxvt with the next command:
```shell
$ echo $TERM
rxvt-unicode-256color
```

### Tabbed for URxvt
This is modified tabbed extension for well known urxvt-unicode terminal emulator.

For installation, configuration and features:

GitHub: https://github.com/gryf/tabbed

### Clipboard with URxvt
**By default**
For *Copying* and *Pasting* with URxvt
* Copy: CTRL + ALT + C
* Paste: CTRL + ALT + V

For changing *Copying* and *Pasting* use this in your configuration file `~/.Xdefaults`

This config will change CTRL + ALT + C; CTRL + ALt + V **in** CTRL + Shift + C; CTRL + Shift + V
```
! Disable ISO 14755 unicode input so we can use Ctrl-Shift bindings
URxvt.iso14755:        false
URxvt.iso14755_52:     false

! Disable Ctrl-Alt-c & Ctrl-Alt-v bindings (optional)
URxvt.keysym.C-M-c:    builtin-string:
URxvt.keysym.C-M-v:    builtin-string:

! Bind Ctrl-Shift-c & Ctrl-Shift-v to copy and paste
! I dont know why, but I needed to use hex keysym values to get it to work
URxvt.keysym.C-S-0x43: eval:selection_to_clipboard
URxvt.keysym.C-S-0x56: eval:paste_clipboard
```

### URxvt Transparency
Urxvt offers two types of transparency for its background :

* A "false" transparency that reproduces the wallpaper in the bottom of the terminal.
(more precisely, the content of the root window of Xorg)
* A "true" transparency, which uses the composition manager that runs.
(xcompmgr, dcompmgr, compiz ...)

If there is no compositing manager running, there is no transparency of everything on a chosen true (composite) transparency.

Edit the `~/.Xdefaults` file and add :
* For **true** transparency (composite) :
```
URxvt*depth: 32
URxvt*background: rgba:0000/0000/0200/c800
```
**OR**
```
URxvt.background: [90]black
```

* For the **false** transparency :
```
URxvt*transparent: true
URxvt*shading: 30
```
> **Note:** If you put both, the false transparency passes before the true transparency (composite).
### URxvt Resize and colors cursor
Append this code to `~/.Xdefaults`
```
!! resize-font
URxvt.resize-font.smaller:	C-Down
URxvt.resize-font.bigger:	C-Up
!! scrollbar-cursors
URxvt.scrollBar:	false
URxvt.cursorColor:	white
```
### URxvt Fonts
* Install font Ubuntu:
```shell
$ sudo apt-get update
$ sudo apt-get install fonts-ubuntu-font-family-console
```

* Modify file and added this line in `~/.Xdefaults`
```
URxvt.font: xft:UbuntuMono-RI:pixelsize=15
```

|Liste Themes|Images des Themes|
|------------|-----------------|
|CodeSchool|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/codeschool/urxvt-unicode-theme-codeschool.png)|
|Embers|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/embers/urxvt-unicode-theme-embers.png)|
|GreenScreen|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/greenscreen/urxvt-unicode-theme-greenscreen.png)|
|GreyScale|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/greyscale/urxvt-unicode-theme-greyscale.png)|
|Isotope|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/isotope/urxvt-unicode-theme-isotope.png)|
|Mocha-Light|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/mocha-light/urxvt-unicode-theme-mocha-light.png)|
|Mocha|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/mocha/urxvt-unicode-theme-mocha.png)|
|Ocean-Light|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/ocean-light/urxvt-unicode-theme-ocean-light.png)|
|Ocean|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/ocean/urxvt-unicode-theme-ocean.png)|
|Paraiso-Light|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/paraiso-light/urxvt-unicode-theme-paraiso-light.png)|
|Paraiso|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/paraiso/urxvt-unicode-theme-paraiso.png)|
|Solarized-Dark|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/solarized-dark/urxvt-unicode-theme-solarized-dark.png)|
|Solarized-Light|![](https://github.com/PhineasPhreak/dotfiles/blob/master/configs/urxvt-unicode/solarized-light/urxvt-unicode-theme-solarized-light.png)|
