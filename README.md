## dotfiles

Very Important: **[List of packages that must be installed](https://github.com/PhineasPhreak/dotfiles/tree/master/packages)**

Configuration Files For my Unix System
* **Xorg, Vim, nano, Bash Shell, Sublime Text 3126/3143/3176, Firewall, Tmux, Fish, terminator, Rofi, polybar, i3wm, urxvt, PyCharm, ranger, vscode**

* PS Book Pentest and Security: **[Git-Pentest](https://github.com/enaqx/awesome-pentest), [Git-Security](https://github.com/sbilly/awesome-security), [Git-Linux](https://github.com/aleksandar-todorovic/awesome-linux), [Git-Python](https://github.com/vinta/awesome-python), [Git-GameHacking](https://github.com/dsasmblr/game-hacking), [Git-HoneyPots](https://github.com/paralax/awesome-honeypots)**

### Xorg For Nvidia
Pour l'installation des [Drivers Nvidia](https://github.com/PhineasPhreak/dotfiles/tree/master/configs/xorg/etc/X11) pour Unix (Kali Linux, Ubuntu, ArchLinux)

Le serveur X se configure automatiquement au démarrage.
Le fichier `/etc/X11/xorg.conf` qui sert à paramétrer le serveur X est donc quasiment vide voire inexistant.

Cependant, dans certains cas, la détection automatique ne fonctionne pas.
Il faut donc paramétrer manuellement ce fichier xorg.conf.

Certaine commande peuvent être utile pour configurer (Console *ou* Graphique) Xorg sous Unix:

`nvidia-setting`, `nvidia-xconfig`, `nvidia-smi`, `X`

* Xorg Wiki: https://fr.wikipedia.org/wiki/X.Org
* Xorg ArchWiki: https://wiki.archlinux.org/index.php/xorg

### Holding packages with dpkg, apt

There are three ways of holding back packages: with dpkg, apt, Synaptic Package Manager.

* **dpkg**

Put a package on hold :

`echo "<package-name> hold" | sudo dpkg --set-selections`

Remove the hold :

`echo "<package-name> install" | sudo dpkg --set-selections`

Display the status of your packages :

`dpkg --get-selections`

Display the status of a single package :

`dpkg --get-selections | grep "<package-name>"`

* **apt**

Hold a package :

`sudo apt-mark hold <package-name>`

Remove the hold :

`sudo apt-mark unhold <package-name>`

* **Synaptic Package Manager**

Go to ***Synaptic Package Manager*** (System > Administration > Synaptic Package Manager).

Click the search button and type the package name.

When you find the package, select it and go to the ***Package*** menu and select ***Lock Version***.

>That package will now not show in the update manager and will not be updated.

***

**Icon GitHub :** [Icon Here](https://octicons.github.com/)

### Site and Others

| **Sites** |                                                   |
| --------- | ------------------------------------------------- |
| Tmux      | GitHub: https://github.com/tmux/tmux/wiki         |
| Fish      | Site: https://fishshell.com/                      |
|           | GitHub: https://github.com/fish-shell/fish-shell  |
|           | GitHub: https://github.com/oh-my-fish/oh-my-fish  |
| Rofi      | GitHub: https://github.com/DaveDavenport/rofi/    |
| Polybar   | GitHub: https://github.com/jaagr/polybar          |
| i3wm      | Site: https://i3wm.org/                           |
|           | GitHub: https://github.com/i3                     |
| awesomewm | Site: https://awesomewm.org/                      |
|           | GitHub: https://github.com/awesomeWM/awesome      |
| ccat      | GitHub: https://github.com/jingweno/ccat/releases |

| **Others**                             |                                    |
| -------------------------------------- | ---------------------------------- |
| Example file of Rice unix Distribution | http://dotshare.it/                |
| Python Awesome                         | https://awesome-python.com/        |
| Packages Python                        | https://pypi.org/                  |
| Reddit                                 | https://www.reddit.com/r/unixporn/ |
| Bash Academy                           | http://www.bash.academy/           |
| DSASMBLR                               | http://dsasmblr.com/               |
| Stephen Chapman *(GitHub)*             | https://github.com/dsasmblr        |

### Thanks
Special thanks go to whom I might have stolen scripts and configs
