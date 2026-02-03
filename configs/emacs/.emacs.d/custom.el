;; -*- coding: utf-8; lexical-binding: t -*-
;; Personal configuration PhineasPhreak (AS PSPK)
;;
;; Do not forget to use Emacs' built-in help system:
;; Use C-h C-h to get an overview of all help commands.  All you
;; need to know about Emacs (what commands exist, what functions do,
;; what variables specify), the help system can provide.
;; Enable LSP support by default in programming buffers
;;
;; My common packages list for IDE (See README.md) :
;; (company, markdown-mode, rainbow-move, buffer-move, csv-mode, shell-pop, auctex, eglot, flycheck, pyvenv)


;; A quick primer on the `use-package' function (refer to
;; "C-h f use-package" for the full details).
;;
;; (use-package my-package-name
;;   :ensure t    ; Ensure my-package is installed or (:ensure nil to not install)
;;   :after foo   ; Load my-package after foo is loaded (seldom used)
;;   :init        ; Run this code before my-package is loaded
;;   :bind        ; Bind these keys to these functions
;;   :custom      ; Set these variables
;;   :config      ; Run this code after my-package is loaded
;;   :hook        ; keyword allows adding functions to hooks.


;; Company is a modular completion framework.  Modules for retrieving completion
;; candidates are called backends, modules for displaying them are frontends.
(use-package company
  :ensure t
  :bind ("C-x w" . company-abort)
  :custom
  ;; Global company mode is enable
  (global-company-mode t)
  ;; The idle delay in seconds until completion starts automatically
  (company-idle-delay 0.1)
  ;; The minimum prefix lenght for idle completion
  (company-minimum-prefix-length 1))

;; markdown-mode is a major mode for editing Markdown-formatted text.
(use-package markdown-mode
  :ensure t)

;; CSV mode, a major mode for editing records
;; in a generalized CSV (character-separated values) format.
(use-package csv-mode
  :ensure t)

;; rainbow-mode, This minor mode sets background color to strings that match color
;; names, e.g. #0000ff is displayed in white with a blue background.
(use-package rainbow-mode
  :ensure t)

;; buffer-move, This file is for lazy people wanting to swap buffers without
;; typing C-x b on each window.
(use-package buffer-move
  :ensure t)

;; This is a utility which helps you pop up and pop out shell buffer window easily.
(use-package shell-pop
  :ensure nil
  :bind ("C-c t" . shell-pop)
  :custom
  (shell-pop-window-position "right")
  (shell-pop-window-size 50)
  (shell-pop-autocd-to-working-dir t)
  (shell-pop-cleanup-buffer-at-process-exit t)
  (shell-pop-full-span t)
  (shell-pop-restore-window-configuration t)
  (shell-pop-shell-type
   '("ansi-term" "*terminal*"
     (lambda nil
       (ansi-term shell-pop-term-shell))))
  (shell-pop-term-shell "/bin/bash"))

;; Adds LSP support. Note that you must have the respective LSP
;; server installed on your machine to use it with Eglot. e.g.
;; rust-analyzer to use Eglot with `rust-mode'. Or,
;; python3-pylsp to use Eglot with `python-mode'.
;; (use-package eglot
;;   :ensure t
;;   :bind (("s-<mouse-1>" . eglot-find-implementation)
;;          ("C-c ." . eglot-code-action-quickfix)))

;; lsp-mode is the primary LSP client for Emacs, and several Python language servers integrate well with it.
;; (use-package lsp-pyright
;;   :ensure t
;;   :hook (python-mode . (lambda () (require 'lsp-pyright) (lsp))))

;; This is a simple global minor mode which will replicate the changes
;; done by virtualenv activation inside Emacs.
;; (use-package pyvenv
;;   :ensure t
;;   :custom
;;   (pyvenv-tracking-mode t))

;; Flycheck is a modern on-the-fly syntax checking extension for GNU Emacs,
;; intended as replacement for the older Flymake extension which is part of GNU Emacs.
;; (use-package flycheck
;;   :ensure t)


;; CUSTOM VARIABLES
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; CUSTOM FACES
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; ADD-HOOK
;; Configue IDE (Packages : eglot, pyvenv)
;; Enable LSP support by default in python buffers
(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'python-mode-hook #'pyvenv-mode)
