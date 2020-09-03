# Vim Configuration

|*Config Advanced*|*Config Basic*|
|:---------------:|:------------:|
|![Vim-config-advanced](https://github.com/PhineasPhreak/dotfiles/blob/master/screenshots/vim-config-advanced.png)|![Vim-config-basic](https://github.com/PhineasPhreak/dotfiles/blob/master/screenshots/vim-config-basic.png)|

## Documentation

Site: http://vimcolors.com/ </br>
Wiki colorsheme: https://vim-fr.org/index.php/Le_colorscheme </br>
Github : https://github.com/vim-airline/vim-airline </br>
Image Shorcut Cheatsheet : [Shorcut VIM](https://github.com/PhineasPhreak/dotfiles/blob/master/screenshots/vim-shortcut-cheatsheet.png)</br>
Github lightline.vim : https://github.com/itchyny/lightline.vim

## Tutorials

Vim help files : [vimhelp.org](https://vimhelp.org/)

## Themes

* Awesome Vim Color Schemes : [Github-awesome-vim-colorschemes](https://github.com/rafi/awesome-vim-colorschemes)
> Collection of awesome color schemes for Vim, merged for quick use.

* PaperColor theme : [Github-papercolor-theme](https://github.com/NLKNguyen/papercolor-theme)
> Light & Dark color schemes for terminal and graphic Vim awesome editor

## Installation configuration file

Put the file at the root of your user/root account:

* For Root : `/root/.vimrc`
* For User : `/home/user/.vimrc`

For the `colorsheme` *OR* `colo`

* For Root : `/root/.vim/colors/`
* For User : `/home/user/.vim/colors/`

**.vimrc**

```shell
pspk@kali:~$ ls -lhA | grep .vimrc
-rw-r--r-- 1 pspk pspk 3.4K Oct  3 00:44 .vimrc
```

### Example of Colorsheme

```shell
pspk@kali:~/.vim/colors$ ls -lh
total 140K
-rw-rw-r-- 1 pspk pspk 6,6K oct.  11 10:13 bocau.vim
-rw-rw-r-- 1 pspk pspk  32K oct.  11 10:13 grubvox.vim
-rw-rw-r-- 1 pspk pspk 7,9K oct.  11 10:13 hemisu.vim
-rw-rw-r-- 1 pspk pspk  17K oct.  11 10:13 hybrid.vim
-rw-rw-r-- 1 pspk pspk  10K oct.  11 10:21 office-dark.vim
-rw-rw-r-- 1 pspk pspk  11K oct.  11 10:21 office-light.vim
-rw-rw-r-- 1 pspk pspk  47K oct.  11 10:13 solarized.vim
```

### Plugin

**Installation manually of `indentLine` :**

```shell
~/.vim/plugin/indentLine.vim
```

Original GitHub: https://github.com/Yggdroot/indentLine

**Installation of `lightline.vim` :**

Original Github: https://github.com/itchyny/lightline.vim

*Thank you*
