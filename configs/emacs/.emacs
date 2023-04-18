;; -*- coding: utf-8; lexical-binding: t -*-
;;
;; Configuration
;; PhineasPhreak (AS PSPK)
;;
;; Emacs Wiki :
;; https://www.emacswiki.org/emacs/SiteMap
;;
;; Smart Configuration for Emacs :
;; https://github.com/patrickt/emacs

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (misterioso)))
 '(global-display-line-numbers-mode t)
 '(inhibit-startup-screen t)
 '(save-place-mode t)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(savehist-mode)
 '(delete-selection-mode t)
 '(set-charset-priority 'unicode)
 '(prefer-coding-system 'utf-8-unix)
 )

(setq
 ;; No need to see GNU agitprop.
 inhibit-startup-screen t

 ;; No need to remind me what a scratch buffer is.
 initial-scratch-message nil

 ;; turn on visible bell
 visible-bell t

 ;; Never ding at me, ever.
 ring-bell-function 'ignore

 ;; search should be case-sensitive by default
 ;case-fold-search nil

 ;; accept 'y' or 'n' instead of yes/no
 ;; the documentation advises against setting this variable
 ;; the documentation can get bent imo
 use-short-answers t

 ;; when I say to quit, I mean quit
 confirm-kill-processes nil

 ;; Emacs is super fond of littering filesystems with backups and autosaves,
 ;; since it was built with the assumption that multiple users could be using
 ;; the same Emacs instance on the same filesystem. This was valid in 1980. It is no longer the case.
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil

 ;; keep the point in the same place while scrolling
 scroll-preserve-screen-position t
 )


(setq-default
 ;; Never mix tabs and spaces. Never use tabs, period.
 ;; We need the setq-default here because this becomes
 ;; a buffer-local variable when set.
 ;indent-tabs-mode nil

 ;; simple mode to highlight trailing whitespaces
 show-trailing-whitespace t
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight semi-bold :height 145 :width normal)))))

