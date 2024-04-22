;; -*- coding: utf-8; lexical-binding: t -*-
;; Personal configuration For IDE
;;
;; Save the contents of this file under ~/.emacs.d/init.el
;; Do not forget to use Emacs' built-in help system:
;; Use C-h C-h to get an overview of all help commands.  All you
;; need to know about Emacs (what commands exist, what functions do,
;; what variables specify), the help system can provide.
;; Enable LSP support by default in programming buffers
;;
;; My common packages list for IDE (See README.md) :
;; (company, markdown-mode, csv-mode, shell-pop, auctex, eglot, flycheck, pyvenv)


;; LANGUAGE SUPPORT
;;; Company support (company-mode)
;; (unless (package-installed-p 'company)
;;   (package-install 'company))

;;; Markdown support
;; (unless (package-installed-p 'markdown-mode)
;;   (package-install 'markdown-mode))

;;; LSP Support
;; (unless (package-installed-p 'eglot)
;;   (package-install 'eglot))

;;; EditorConfig support
;; (unless (package-installed-p 'editorconfig)
;;   (package-install 'editorconfig))

;;; csv-mode support
;; (unless (package-installed-p 'csv-mode)
;;   (package-install 'csv-mode))

;;; shell-pop support
;; (unless (package-installed-p 'shell-pop)
;;   (package-install 'shell-pop))

;;; pyvenv-mode support
;; (unless (package-installed-p 'pyvenv-mode)
;;   (package-install 'pyvenv))

;; CUSTOM VARIABLES
(custom-set-variables
 '(shell-pop-autocd-to-working-dir t)
 '(shell-pop-cleanup-buffer-at-process-exit t)
 '(shell-pop-full-span t)
 '(shell-pop-restore-window-configuration t)
 '(shell-pop-shell-type
   '("ansi-term" "*terminal*"
     (lambda nil
       (ansi-term shell-pop-term-shell))))
 '(shell-pop-term-shell "/bin/bash")
 '(shell-pop-universal-key "C-c t")
 '(shell-pop-window-position "right")
 '(shell-pop-window-size 50)
 )

;; CUSTOM FACES
(custom-set-faces
 '(flymake-warning ((t nil)))
 )
;; COMPANY
(global-company-mode 1)
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 1)

;; PYTHON
;; Configue IDE (Packages : eglot, pyvenv)
;; Enable LSP support by default in python buffers
(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'python-mode-hook #'pyvenv-mode)

;; PYVENV
;; Automatically use pyvenv-workon via dir-locals
;; (setq pyvenv-tracking-mode 1)

