;; -*- coding: utf-8; lexical-binding: t -*-
;;
;; Configuration
;; PhineasPhreak (AS PSPK)
;;
;; Emacs Wiki :
;; - https://www.emacswiki.org/emacs/SiteMap
;;
;; Emacs Configuration Generator :
;; - https://emacs.amodernist.com/
;;
;; Info :
;; More information about Variable use C-h v <variable> for help.
;; More information about Function use C-h f <function> for help.
;; More information about Bindings use C-h b <bindings> for help.
;; More information about Key use C-h k <key> for help.
;;
;; Example :
;; - Smart Configuration for Emacs :
;;   https://github.com/patrickt/emacs
;; - Everything with Emacs :
;;   https://irfu.cea.fr/Pisp/vianney.lebouteiller/emacs.html
;; - Kevin Borling <https://github.com/kborling>
;;   https://gist.github.com/kborling/13f2300e60ae4878d5d96f5f4d041664
;; - The best way to open remote file :
;;   https://www.gnu.org/software/emacs/manual/html_node/emacs/Remote-Files.html
;;
;;
;; Packages :
;; Added by Package.el. This must come before configurations of
;; installed packages. Don't delete this line. If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;
;; The most common method of installing packages of Emacs Lisp
;; From: https://www.emacswiki.org/emacs/InstallingPackages
;; My common packages list (See README.md) :
;; (company, markdown-mode, rainbow-move, buffer-move, csv-mode, shell-pop, auctex, eglot, flycheck, pyvenv)


;; Activate all the packages (in particular autoloads)
(package-initialize)

;; This code starts the server only if it's not running
;; (load "server")
;; (unless (server-running-p) (server-start))

;; List the repositories containing them ("gnu" by default)
(require 'package)
;; Installed by default from Emacs 28 onwards
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))

;; Additional package archives such as MELPA exist to supplement what is in GnuELPA.
;; From: https://www.emacswiki.org/emacs/MELPA
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))

;; To ensure Emacs can find your custom themes in "~/.emacs.d/themes/",
;; Note: Ensure the directory contains valid theme files (e.g., my-theme-theme.el)
;; and that the file names follow the correct naming convention.
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; Start the initial frame maximized
;; https://emacsredux.com/blog/2020/12/04/maximize-the-emacs-frame-on-startup/
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))
;;
;; Start every frame maximized
;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

;; This ensures that show-trailing-whitespace is disabled specifically in
;; term-mode, minibuffer and diff-mode buffers, preventing the display of trailing whitespace in terminal-like buffers.
(add-hook 'Buffer-menu-mode-hook (lambda () (setq-local show-trailing-whitespace nil)))
(add-hook 'term-mode-hook (lambda () (setq-local show-trailing-whitespace nil)))
(add-hook 'eshell-mode-hook (lambda () (setq-local show-trailing-whitespace nil)))
(add-hook 'diff-mode-hook (lambda () (setq-local show-trailing-whitespace nil)))
(add-hook 'calendar-mode-hook (lambda () (setq-local show-trailing-whitespace nil)))
;; (add-hook 'minibuffer-setup-hook (lambda () (setq-local show-trailing-whitespace nil)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;
;; Options
;;
;; Load default theme
(load-theme 'wombat t)

;; Setting the default directory (for Windows)
;; (setq default-directory "C:\\Users\\pspk\\")

;; Set default font face
;; (set-face-attribute 'default nil :font "JetBrains Mono")

;; No need to see GNU agitprop.
(setq inhibit-startup-screen t)

;; Set the initial major-mode in text-mode
(setq initial-major-mode 'text-mode)

;; Docs : https://emacsredux.com/blog/2014/07/25/configure-the-scratch-buffers-mode/
;; Custom the buffer’s initial contents, or 'nil' for nothing.
;; (setq initial-scratch-message "\
;; # This buffer is for notes you don't want to save, and for code or just text.
;; # If you want to create a file, visit that file with C-x C-f,
;; # then enter the text in that file's own buffer.\n\n")
;;
;; Or, no need to remind me what a scratch buffer is.
(setq initial-scratch-message nil)

;; Faces used for SGR control sequences determining a face
(setq ansi-color-faces-vector
      [default default default italic underline success warning error])

;; Colors used for SGR control sequences determining a color
(setq ansi-color-names-vector
      ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])

;; Number of lines and margin at the top and bottom of a window
;; (setq scroll-margin 7)

;; Toggle column number display in the mode line (Column Number mode)
(setq column-number-mode t)

;; Toggle Delete Selection mode
(setq delete-selection-mode t)

;; Toggle Display-Line-Numbers mode in all buffers
(setq global-display-line-numbers-mode t)

;; If non-nil, the dictionary to be used for Ispell commands in this buffer
(setq ispell-dictionary nil)

;; Save place in history file
(save-place-mode t)

;; Toggle saving of minibuffer history (Savehist mode)
(setq savehist-mode nil)

;; Toggle visualization of matching parens (Show Paren mode)
(setq show-paren-mode t)

;; Toggle buffer size display in the mode line (Size Indication mode)
(setq size-indication-mode t)

;; Toggle display of a menu bar on each frame (Menu Bar mode)
;; (setq menu-bar-mode nil)

;; Toggle the tool bar in all graphical frames (Tool Bar mode)
(setq tool-bar-mode nil)

;; Specify whether to have vertical scroll bars, and on which side.
;; (setq scroll-bar-mode nil)

;; Turn on visible bell
(setq visible-bell t)

;; Never ding at me, ever.
(setq ring-bell-function 'ignore)

;; Search should be case-sensitive by default
;; (setq case-fold-search nil)

;; Accept 'y' or 'n' instead of yes/no
;; the documentation advises against setting this variable
;; the documentation can get bent imo
(setq use-short-answers t)

;; When I say to quit, I mean quit
(setq confirm-kill-processes nil)

;; Emacs is super fond of littering filesystems with backups and autosaves,
;; since it was built with the assumption that multiple users could be using
;; the same Emacs instance on the same filesystem. This was valid in 1980. It is no longer the case.
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

;; Keep the point in the same place while scrolling
(setq scroll-preserve-screen-position t)

;; You can control the amount in variable
(setq mouse-wheel-scroll-amount '(0.07 ((shift) . 10)))

;; Nicer behaviour for the scrolling
(setq mouse-wheel-progressive-speed nil)

;; Enable indentation+completion using the TAB key.
(setq tab-always-indent 'complete)

;; Make the minibuffer case-insensitive
(setq completion-ignore-case t)

;; When completing file names, make case-insensitive
(setq read-file-name-completion-ignore-case t)

;; When switch the buffer make case-insensitive
(setq read-buffer-completion-ignore-case t)

;; Keep files up-to-date when they change outside Emacs
(global-auto-revert-mode t)

;; Automatically pair parentheses
(electric-pair-mode t)

;; Prefer coding system
(prefer-coding-system 'utf-8)

;; Assign higher priority to the charsets given as arguments
(set-charset-priority 'unicode)

;; Toggle use of Ido for all buffer/file reading.
(ido-mode t)
(ido-everywhere t)

;; Switch focus after buffer split in emacs.
;; Unfortunately, though, this has the side-effect of selecting the *Completions* buffer when you hit TAB in the minibuffer.
;; (defadvice split-window (after move-point-to-new-window activate)
;;   "Moves the point to the newly created window after splitting."
;;   (other-window 1))

;;
;; Indentation
;;
;; Never mix tabs and spaces. Never use tabs, period.
;; We need the setq-default here because this becomes
;; a buffer-local variable when set.
(setq-default
 indent-tabs-mode nil
 ;; Simple mode to highlight trailing whitespaces
 show-trailing-whitespace t
 tab-stop-list    ()
 tab-width        4
 )

;;
;; Whitespace
;;
;; Determine the kinds of whitespace are visualized, with a specific value. See option whitespace-style for more information.
(setq whitespace-style (quote (face spaces tabs space-mark tab-mark trailing)))

;;
;; Keybindings
;;
(let ((map global-map))
  ;; Remove suspend
  ;(define-key map (kbd "C-z") nil)
  ;(define-key map (kbd "C-x C-z") nil)

  ;; Clean Whitespace
  ;; Cleanup some blank problems in all buffer or at region
  (define-key map (kbd "C-c .") #'whitespace-cleanup)

  ;; Cleanup some blank problems at region. By default the cleanup includes both deleting and other fixes
  (define-key map (kbd "C-c /") #'whitespace-cleanup-region)

  ;; To fixup white space between objects around point according to the context
  ;; (define-key map (kbd "C-c C-c") #'fixup-whitespace)

  (define-key map (kbd "C-c ,") #'whitespace-mode)
  (define-key map (kbd "C-.") #'global-whitespace-mode)

  (define-key map (kbd "C-c a") #'mark-whole-buffer)
  (define-key map (kbd "C-c d") #'kill-whole-line)
  (define-key map (kbd "C-x ,") #'revert-buffer)
  (define-key map (kbd "C-c ;") #'comment-line)
  (define-key map (kbd "C-x w") #'keyboard-escape-quit)
  (define-key map (kbd "C-c s") #'window-swap-states)
  (define-key map (kbd "C-c `") #'not-modified)

  (define-key map (kbd "C-c 2") #'split-root-window-below)
  (define-key map (kbd "C-c 3") #'split-root-window-right)

  (define-key map (kbd "C-<tab>") #'other-window)
  (define-key map (kbd "C-c <TAB>") #'other-window)
  ;; (define-key map (kbd "C-t") #'other-window)

  ;; (define-key map (kbd "C-c C-<tab>") #'next-window)
  ;; (define-key map (kbd "C-c C-p") #'previous-buffer)
  ;; (define-key map (kbd "C-c C-n") #'next-buffer)

  ;; Misc
  ;; (define-key map (kbd "C-x C-b") #'ibuffer)
  ;; (define-key map (kbd "M-z") #'zap-up-to-char)

  ;; Isearch
  ;; (define-key map (kbd "C-s") #'isearch-forward-regexp)
  ;; (define-key map (kbd "C-r") #'isearch-backward-regexp)
  ;; (define-key map (kbd "C-M-s") #'isearch-forward)
  ;; (define-key map (kbd "C-M-r") #'isearch-backward)

  ;; Open applications
  ;; (define-key map (kbd "C-c o e") #'eshell)
  ;; (define-key map (kbd "C-c o d") #'dired)
  ;; (define-key map (kbd "C-c o f") #'treemacs)

  ;; Package 'buffer-move'
  ;; The buffer-move package lets you move the contents (buffer) of a window in another direction, using keyboard shortcuts
  ;; (global-set-key (kbd "C-x c <up>")    #'buf-move-up)
  ;; (global-set-key (kbd "C-x c <down>")  #'buf-move-down)
  ;; (global-set-key (kbd "C-x c <left>")  #'buf-move-left)
  ;; (global-set-key (kbd "C-x c <right>") #'buf-move-right)
  )

;; https://www.emacswiki.org/emacs/WindowResize
;; Here is a very simple suggestion to make them more accessible.
(global-set-key (kbd "S-C-<left>")  #'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") #'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>")  #'shrink-window)
(global-set-key (kbd "S-C-<up>")    #'enlarge-window)
(global-set-key (kbd "C-x +")       #'balance-windows)

;;
;; Functions
;;
;; Enable this variable to automatically kill the current Dired buffer when opening a new one. (in Emacs 28+)
;; (setf dired-kill-when-opening-new-dired-buffer t)

;; Docs: https://www.emacswiki.org/emacs/CopyingWholeLines#h5o-10
;; Duplicate the current line
(defun duplicate-current-line (&optional n)
  "duplicate current line, make more than 1 copy given a numeric argument"
  (interactive "p")
  (save-excursion
    (let ((nb (or n 1))
          (current-line (thing-at-point 'line)))
      ;; when on last line, insert a newline first
      (when (or (= 1 (forward-line 1)) (eq (point) (point-max)))
        (insert "\n"))

      ;; now insert as many time as requested
      (while (> n 0)
        (insert current-line)
        (decf n)))))
;; Key bindings for duplicate-current-line
(global-set-key (kbd "C-c w") 'duplicate-current-line)


;; Docs: https://www.emacswiki.org/emacs/CopyingWholeLines#h5o-5
;; Copy the whole current line
(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))
;; Key bindings for copy-line
(global-set-key (kbd "C-c c") 'copy-line)


;; Docs: https://stackoverflow.com/questions/637351/emacs-how-to-delete-text-without-kill-ring
;; Emacs: how to delete text without kill ring
(defun ruthlessly-kill-line ()
  "Deletes a line, but does not put it in the kill-ring."
  (interactive)
  (move-beginning-of-line 1)
  (kill-line 1)
  (setq kill-ring (cdr kill-ring)))
;; Key bindings for delete line without kill ring
(global-set-key (kbd "C-c D") 'ruthlessly-kill-line)


;; Delete text not kill it into kill-ring
;; https://www.reddit.com/r/emacs/comments/2ny06e/delete_text_not_kill_it_into_killring/
;; https://www.reddit.com/r/emacs/comments/2s0hiq/how_can_i_make_backwardkillword_not_save_to_the/
;; https://www.emacswiki.org/emacs/BackwardDeleteWord
(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times.
This command does not push erased text to kill-ring."
  (interactive "p")
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-region (point) (progn (forward-word arg) (point)))))
;; Key bindings for delete-word
(global-set-key (kbd "M-<delete>") 'delete-word)


(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument, do this that many times.
This command does not push erased text to kill-ring."
  (interactive "p")
  (delete-word (- arg)))
;; Key bindings for backward-delete-word
(global-set-key (kbd "M-<backspace>") 'backward-delete-word)


(defun my-delete-line ()
  "Delete text from current position to end of line char."
  (interactive)
  (let (x1 x2)
    (setq x1 (point))
    (move-end-of-line 1)
    (setq x2 (point))
    (delete-region x1 x2)))
;; Key bindings for delete-line
(global-set-key (kbd "M-K") 'my-delete-line)


(defun my-delete-line-backward ()
  "Delete text between the beginning of the line to the cursor position."
  (interactive)
  (let (x1 x2)
    (setq x1 (point))
    (move-beginning-of-line 1)
    (setq x2 (point))
    (delete-region x1 x2)))
;; Key bindings for delete-line-backward
(global-set-key (kbd "C-c k") 'my-delete-line-backward)


(defun my-kill-thing-at-point (thing)
  "Kill the 'thing-at-point' for the specified kind of THING."
  (let ((bounds (bounds-of-thing-at-point thing)))
    (if bounds
        (kill-region (car bounds) (cdr bounds))
      (error "No %s at point" thing))))

(defun my-kill-word-at-point ()
  "Kill the word at point."
  (interactive)
  (my-kill-thing-at-point 'word))
;; Key bindings for my-kill-word-at-point (s in lowersace mean Super Key)
(global-set-key (kbd "s-k k") 'my-kill-word-at-point)


(defun my-delete-thing-at-point (thing)
  "Delete the 'thing-at-point' for the specified kind of THING.
Delete the word, but does not put it in the kill-ring."
  (let ((bounds (bounds-of-thing-at-point thing)))
    (if bounds
        (delete-region (car bounds) (cdr bounds))
      (error "No %s at point" thing))))

(defun my-delete-word-at-point ()
  "Kill the word at point."
  (interactive)
  (my-delete-thing-at-point 'word))
;; Key bindings for my-kill-word-at-point (s in lowersace mean Super Key)
(global-set-key (kbd "s-k K") 'my-delete-word-at-point)


;; Can I use 'y-or-n-p' always, or 'yes-or-no-p' always?
;; If you want to use 'y' always, do this.
(defalias 'yes-or-no-p 'y-or-n-p)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Store automatic customisation options elsewhere
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; https://emacs.stackexchange.com/questions/7151/is-there-a-way-to-detect-that-emacs-is-running-in-a-terminal
;; https://emacs.stackexchange.com/questions/13050/different-theme-for-nw-terminal
;; (when (display-graphic-p)
;;   ;; Do any keybindings and theme setup here
;;   (load-theme 'wombat t)
;;   )

;; A way to detect that emacs is running in a terminal
(unless (display-graphic-p)
  ;; Remove any keybindings and theme setup here
  (load-theme 'wombat t)

  ;; Enable mouse support in terminal
  (xterm-mouse-mode 1)

  ;; Changed the xterm-standard-colors variable
  ;; (set 'xterm-standard-colors
  ;;      '(("black"          0 (  0   0   0))
  ;;        ("red"            1 (255   0   0))
  ;;        ("green"          2 (  0 255   0))
  ;;        ("yellow"         3 (255 255   0))
  ;;        ("blue"           4 (  0   0 255))
  ;;        ("magenta"        5 (255   0 255))
  ;;        ("cyan"           6 (  0 255 255))
  ;;        ("white"          7 (255 255 255))
  ;;        ("brightblack"    8 (127 127 127))
  ;;        ("brightred"      9 (255   0   0))
  ;;        ("brightgreen"   10 (  0 255   0))
  ;;        ("brightyellow"  11 (255 255   0))
  ;;        ("brightblue"    12 (92   92 255))
  ;;        ("brightmagenta" 13 (255   0 255))
  ;;        ("brightcyan"    14 (  0 255 255))
  ;;        ("brightwhite"   15 (255 255 255)))
  ;;      )
  )
