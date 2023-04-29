;; -*- coding: utf-8; lexical-binding: t -*-
;;
;; Configuration
;; PhineasPhreak (AS PSPK)
;;
;; Emacs Wiki :
;; https://www.emacswiki.org/emacs/SiteMap
;;
;; Info :
;; More information about Variable use C-h v <variable> for help.
;;
;; Example :
;; - Smart Configuration for Emacs :
;;   https://github.com/patrickt/emacs
;; - Everything with Emacs
;;   https://irfu.cea.fr/Pisp/vianney.lebouteiller/emacs.html
;; - Kevin Borling <https://github.com/kborling>
;;   https://gist.github.com/kborling/13f2300e60ae4878d5d96f5f4d041664


;; Packages :
;; Added by Package.el. This must come before configurations of
;; installed packages. Don't delete this line. If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;
;; The most common method of installing packages of Emacs Lisp
;; From: https://www.emacswiki.org/emacs/InstallingPackages

;; Activate all the packages (in particular autoloads)
(package-initialize)

;; Additional package archives such as MELPA exist to supplement what is in GnuELPA.
;; From: https://www.emacswiki.org/emacs/MELPA
;; List the repositories containing them
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))

;; List the packages you want
;(setq package-list '(use-package markdown-mode))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (wombat)))
 '(delete-selection-mode t)
 '(global-display-line-numbers-mode t)
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (markdown-mode)))
 '(prefer-coding-system (quote utf-8-unix))
 '(save-place-mode t)
 '(savehist-mode nil)
 '(scroll-margin 7)
 '(set-charset-priority (quote unicode))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))


;; No need to see GNU agitprop.
(setq inhibit-startup-screen t)

;; No need to remind me what a scratch buffer is.
(setq initial-scratch-message nil)

;; Turn on visible bell
(setq visible-bell t)

;; Never ding at me, ever.
(setq ring-bell-function 'ignore)

;; Search should be case-sensitive by default
;(setq case-fold-search nil)

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
(setq mouse-wheel-scroll-amount '(0.07 ((shift) . 1) ((control) . 10)))

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

;; Indentation
(setq-default indent-tabs-mode nil
              tab-stop-list    ()
              tab-width        4)

(setq-default
 ;; Never mix tabs and spaces. Never use tabs, period.
 ;; We need the setq-default here because this becomes
 ;; a buffer-local variable when set.
 ;indent-tabs-mode nil

 ;; Simple mode to highlight trailing whitespaces
 show-trailing-whitespace t)

;;
;; Keybindings
;;
(let ((map global-map))
  ;; Remove suspend
  ;(define-key map (kbd "C-z") nil)
  ;(define-key map (kbd "C-x C-z") nil)

  (define-key map (kbd "C-;") #'comment-line)

  (define-key map (kbd "C-x w") #'other-window)
  ;(define-key map (kbd "C-t") #'other-window)

  ;(define-key map (kbd "C-c C-<tab>") #'next-window)
  ;(define-key map (kbd "C-c C-p") #'previous-buffer)
  ;(define-key map (kbd "C-c C-n") #'next-buffer)

  ;; Misc
  ;(define-key map (kbd "C-x C-b") #'ibuffer)
  ;(define-key map (kbd "M-z") #'zap-up-to-char)

  ;; Isearch
  ;(define-key map (kbd "C-s") #'isearch-forward-regexp)
  ;(define-key map (kbd "C-r") #'isearch-backward-regexp)
  ;(define-key map (kbd "C-M-s") #'isearch-forward)
  ;(define-key map (kbd "C-M-r") #'isearch-backward)

  ;; Open applications
  ;(define-key map (kbd "C-c o e") #'eshell)
  ;(define-key map (kbd "C-c o d") #'dired)
  ;(define-key map (kbd "C-c o f") #'treemacs)
  )

;; Can I use 'y-or-n-p' always, or 'yes-or-no-p' always?
;; If you want to use 'y' always, do this.
(defalias 'yes-or-no-p 'y-or-n-p)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight semi-bold :height 134 :width normal)))))

;; Switch focus after buffer split in emacs.
;; Unfortunately, though, this has the side-effect of selecting the *Completions* buffer when you hit TAB in the minibuffer.
;(defadvice split-window (after move-point-to-new-window activate)
;  "Moves the point to the newly created window after splitting."
;  (other-window 1))
