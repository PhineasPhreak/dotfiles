# Emacs Configuration
**The GNU Emacs manual is available in the following formats**: [Emacs manual](https://www.gnu.org/software/emacs/manual/emacs.html) or [The Emacs Editor](https://emacsdocs.org/docs/emacs/The-Emacs-Editor)

The [EmacsWiki](https://www.emacswiki.org/emacs/SiteMap) is dedicated to documenting and discussing [EmacsAndXEmacs](https://www.emacswiki.org/emacs/EmacsAndXEmacs) and [EmacsLisp](https://www.emacswiki.org/emacs/EmacsLisp). See the [MissionStatement](https://www.emacswiki.org/emacs/MissionStatement) for more information.

Emacs Configuration Generator : [here](https://emacs.amodernist.com/)

## Installing the configuration file
- **Linux :**

    Copy `.emacs` in your home directory (or, `init.el` in `~/.emacs/init.el`)

    Copy `custom.el` in your emacs config directory `~/.emacs.d/`

- **Windows :**

    Copy `.emacs` in `C:\Users\<username>\AppData\Roaming`

## Installing packages
The *melpa-stable* directory has already been added to the `.emacs` configuration file.
To see how to add other directories, see the [emacs.wiki](https://www.emacswiki.org/emacs/MELPA) and the list of [melpa-stable](https://stable.melpa.org/#/) and [melpa](https://melpa.org/#/) packages.

To install one or more packages, press `M+x` (Alt+x) in Emacs, then type the `list-packages` command. Select the packages you wish to install.

**Packages :**

- Themes :
  - `atom-one-dark-theme-0.4.0` : An Emacs port of the Atom One Dark theme from Atom.io.

- Mode :
  - `buffer-mode` : The buffer-move package lets you move the contents (buffer) of a window in another direction, using keyboard shortcuts [Github](https://github.com/lukhas/buffer-move)
  - `csv-mode` : Major mode for editing comma/char separated values
  - `markdown-mode` : Major mode for Markdown-formatted text
  - `auctex` : Integrated environment for *TeX*
  - `shell-pop` : helps you to use shell easily on Emacs. Only one key action to work [Github](https://github.com/kyagi/shell-pop-el)
  - `company` : Modular in-buffer completion framework for Emacs [Site](https://company-mode.github.io/)|[Github](https://github.com/company-mode/company-mode)
  - `flycheck` : Syntax checking for GNU Emacs [Site](https://www.flycheck.org/en/latest/)
  - `eglot` : The Emacs Client for LSP servers [Github](https://github.com/joaotavora/eglot)

## How do I remove the gap around maximized Emacs frame on KDE?
Link question : [here](https://askubuntu.com/questions/787694/how-do-i-remove-the-gap-around-maximized-emacs-frame-on-kde)

This is more of a workaround than a fix. As proposed by Bastian Beischer in [this thread](http://lists.gnu.org/archive/html/help-gnu-emacs/2011-02/msg00173.html) you can change how the window obeys the changes in geometry.

As some names of menu entries have changed, here is an updated version:

    1. Right click on the title bar.
    2. Select `More Actions` -> `Special Application Settings`
    3. In the `Size & Positions`-Tab activate `Obey Geometry Restrictions`
    4. Set the value in the drop-down list to `Force` and keep the radio button next to it on `No`

This solved the problem for me. It worked for all instances of Emacs on my machine and did so persistently after restart. It also works on Ubuntu 16.04 with Plasma 5.5.5 and Emacs 25.2. Emacs 29.0.50 and Kwin 5.25.5 also work.

> Edit:
> I tried to figure out what the difference between Special Window Settings and Special Application Settings is. [This answer](https://unix.stackexchange.com/a/45694/133739) over on SE Unix&Linux suggests this change would only apply for the specific window, but I could not reproduce this. For me it changes for all windows.
