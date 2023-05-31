# Emacs Configuration
The [EmacsWiki](https://www.emacswiki.org/emacs/SiteMap) is dedicated to documenting and discussing [EmacsAndXEmacs](https://www.emacswiki.org/emacs/EmacsAndXEmacs) and [EmacsLisp](https://www.emacswiki.org/emacs/EmacsLisp). See the [MissionStatement](https://www.emacswiki.org/emacs/MissionStatement) for more information.

## Installation
* Linux :

  Copy `.emacs` in your home directory

* Windows :

  Copy `.emacs` in `C:\Users\<username>\AppData\Roaming`

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
