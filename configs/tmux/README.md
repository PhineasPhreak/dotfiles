# 'tmux' Package Configuration
**what is tmux ?** </br>
Is a terminal multiplexer: it enables a number of terminals, each running a separate program to be created, accessed and controlled from a single screen.

## How do I translate -fg, -bg and -attr options into -style options?
Wiki tmux : https://github.com/tmux/tmux/wiki/FAQ#how-do-i-translate--fg--bg-and--attr-options-into--style-options

## Installation:
Copy this file `.tmux.conf` to a root directory.
```
~/.tmux.conf
```

## Vi mode in tmux
You can enable this as a default setting in `.tmux.conf` with the following:
```shell
# Use vi keys in buffer
setw -g mode-keys vi
```
![tmux-config-classic](https://github.com/PhineasPhreak/dotfiles/blob/master/screenshots/tmux-config-mode-keys-vi.png)

## Site:
GitHub: https://github.com/tmux/tmux/wiki
