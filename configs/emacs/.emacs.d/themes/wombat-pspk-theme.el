;;; wombat-pspk-theme.el --- Custom face theme for Emacs  -*- lexical-binding:t -*-
;;
;; Copyright (C) 2011-2026 Free Software Foundation, Inc.
;;
;; Author: Kristoffer Grönlund <krig@koru.se>
;;
;; This file is part of GNU Emacs.
;;
;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.
;;
;; Original code for this theme from Github.
;; - Link : https://github.com/emacs-mirror/emacs/blob/master/etc/themes/wombat-theme.el
;;
;;; Code:


;;;###theme-autoload
(deftheme wombat-pspk
  "PSPK version, Medium-contrast faces with a dark gray background.
Adapted, with permission, from a Vim color scheme by Lars H. Nielsen.
Basic, Font Lock, Isearch, Gnus, Message, and Ansi-Color faces
are included. Custom by Phineasphreak (as PSPK)"
  :background-mode 'dark
  :kind 'color-scheme)

;; Please install rainbow-mode
(let ((class '((class color) (min-colors 89)))
      ;;Generic       ~~RGB~~
      (act1          "#222225")
      (act2          "#5d4d7a")
      (base          "#f6f3e8")
      (base-dim      "#99968b")
      (bg-1          "#202020")
      (bg1           "#242424")
      (bg2           "#303030")
      (bg3           "#444444")
      (bg4           "#505050")
      (bg5           "#545454")
      (bg-alt        "#42444a")
      (border        "#383838")
      (cblk          "#cbc1d5")
      (cblk-bg       "#2f2b33")
      (cblk-ln       "#827591")
      (cblk-ln-bg    "#151515")
      (cursor        "#b2b2b2")
      (const         "#e59677")
      (comment       "#99968b")
      (comment-light "#cbc7b9")
      (comment-bg    "#292e34")
      (comp          "#e5786d")
      (err           "#b85149")
      (func          "#cae682")
      (head1         "#4f97d7")
      (head1-bg      "#293239")
      (head2         "#2d9574")
      (head2-bg      "#293235")
      (head3         "#67b11d")
      (head3-bg      "#293235")
      (head4         "#b1951d")
      (head4-bg      "#32322c")
      (highlight     "#404040")
      (highlight-dim "#828282")
      (keyword       "#e5786d")
      (keyword-fl    "#8ac6f2")
      (lnum          "#44505c")
      (mat           "#95e454")
      (meta          "#95e470")
      (str           "#98c098")
      (suc           "#95e454")
      (ttip          "#9a9aba")
      (ttip-sl       "#99968b")
      (ttip-bg       "#34323e")
      (type          "#92a65e")
      (var           "#7590db")
      (war           "#ddaa6f")
      (war-dim       "#dc752f")

      (isearch-bg    "#343434")
      (isearch-fg    "#857b6f")
      (lazy-hl-bg    "#384048")
      (lazy-hl-fg    "#a0a8b0")
      (mini-buffer   "#b85149")
      (buffer-name   "#ddaa6f")

      ;; Colors
      (aqua          "#2d9574")
      (aqua-bg       "#293235")
      (black         "#242424")
      (green         "#92a65e")
      (green-bg      "#293235")
      (green-bg-s    "#29422d")
      (cyan          "#3f9f9e")
      (red           "#b85149")
      (red-bg        "#3c2a2c")
      (red-bg-s      "#512e31")
      (blue          "#5b98c2")
      (blue-bg       "#293239")
      (blue-bg-s     "#2d4252")
      (magenta       "#64619a")
      (yellow        "#ccaa8f")
      (yellow-bg     "#32322c")
      (gray          "#b2b2b2")
      (white         "#f6f3e8"))


  (custom-theme-set-faces
   'wombat-pspk

   ;; DEFAULT FONT / CURSOR COLOR
   `(default ((,class (:background ,bg1 :foreground ,base))))
   `(cursor ((,class (:background ,cursor))))

   ;; BASIC HIGHLIGHTING FACES
   `(border ((,class (:background ,bg-1 :foreground ,border))))
   `(vertical-border ((,class (:foreground ,border))))
   `(success ((,class (:foreground ,suc))))
   `(warning ((,class (:foreground ,war))))
   `(error ((,class (:foreground ,err))))
   `(fringe ((,class (:background ,bg1))))
   `(shadow ((,class (:foreground ,base-dim))))
   `(match ((,class (:background ,highlight :foreground ,mat))))
   `(eval-sexp-fu-flash ((,class (:background ,suc :foreground ,bg1))))
   `(eval-sexp-fu-flash-error ((,class (:background ,err :foreground ,bg1))))
   `(header-line ((,class :background ,bg2)))
   `(hl-line ((,class (:background ,bg2 :extend t))))
   `(highlight ((,class (:background ,highlight :foreground ,base :underline t))))
   `(region ((,class (:background ,highlight :extend t))))
   `(secondary-selection ((,class (:background ,highlight :foreground unspecified))))
   `(lazy-highlight ((,class (:background ,lazy-hl-bg :foreground ,lazy-hl-fg))))
   `(tooltip ((,class (:background ,ttip-sl :foreground ,base :bold nil :italic nil :underline nil))))
   `(custom-state ((,class (:foreground ,green))))
   `(highlight-changes ((,class (:foreground ,green))))

   ;; MODE LINE FACES
   `(mode-line ((,class (:background ,bg3 :foreground ,base :box (:color ,bg3 :line-width 1)))))
   `(mode-line-inactive ((,class (:background ,bg1 :foreground ,bg5 :box (:color ,bg3 :line-width 1)))))
   `(mode-line-buffer-id ((,class (:background unspecified :foreground ,buffer-name :weight bold))))
   `(mode-line-emphasis ((,class (:weight bold))))

   ;; ISEARCH
   `(isearch ((,class (:foreground ,isearch-fg :background ,isearch-bg))))
   `(isearch-fail ((,class (:foreground ,black :background ,red))))
   `(isearch-lazy-highlight-face ((,class (:foreground ,lazy-hl-fg :background ,lazy-hl-bg))))

   ;; TAB-BAR-MODE
   `(tab-bar ((,class (:foreground ,base :background ,bg1))))
   `(tab-bar-tab ((,class (:foreground ,base :background ,bg1 :weight bold))))
   `(tab-bar-tab-inactive ((,class (:foreground ,base-dim :background ,bg2 :weight light))))

   ;; TAB-LINE-MODE
   `(tab-line ((,class (:foreground ,base :background ,bg1))))
   `(tab-line-tab-current ((,class (:foreground ,base :background ,bg1 :weight bold))))
   `(tab-line-tab-inactive ((,class (:foreground ,base-dim :background ,bg2 :weight light))))

   ;; ESCAPE AND PROMPT FACES
   `(minibuffer-prompt ((,class (:foreground ,mini-buffer :weight bold))))
   `(escape-glyph ((,class (:foreground "#ddaa6f" :weight bold))))
   `(homoglyph ((,class (:foreground "#ddaa6f" :weight bold))))

   ;; FONT LOCK FACES
   `(font-lock-builtin-face ((,class (:foreground "#e5786d"))))
   `(font-lock-comment-face ((,class (:foreground "#99968b"))))
   `(font-lock-comment-delimiter-face ((,class (:foreground "#99968b"))))
   `(font-lock-constant-face ((,class (:foreground "#e59677"))))
   `(font-lock-doc-face ((,class (:foreground "#95e470"))))
   `(font-lock-doc-string-face ((,class (:foreground "#95e470"))))
   `(font-lock-function-name-face ((,class (:foreground "#7590db" :weight bold))))
   `(font-lock-keyword-face ((,class (:foreground "#8ac6f2" :weight bold))))
   `(font-lock-string-face ((,class (:foreground "#98c098"))))
   `(font-lock-reference-face ((,class (:foreground "#e59677"))))
   `(font-lock-preprocessor-face ((,class (:foreground "#e59677"))))
   `(font-lock-type-face ((,class (:foreground "#92a65e" :weight bold))))
   `(font-lock-variable-name-face ((,class (:foreground "#cae682"))))
   `(font-lock-warning-face ((,class (:foreground "#ccaa8f"))))
   `(font-lock-operator-face ((,class (:foreground "#716cff"))))

   ;; HELP FACES
   `(help-key-binding ((,class (:background "#333333" :foreground "#f6f3e8"))))

   ;; INFO
   `(info-header-xref ((,class (:foreground ,func :underline t))))
   `(info-menu ((,class (:foreground ,suc))))
   `(info-node ((,class (:foreground ,func :inherit bold))))
   `(info-quoted-name ((,class (:foreground ,keyword))))
   `(info-reference-item ((,class (:background unspecified :underline t :inherit bold))))
   `(info-string ((,class (:foreground ,str))))
   `(info-title-1 ((,class (:height 1.4 :inherit bold))))
   `(info-title-2 ((,class (:height 1.3 :inherit bold))))
   `(info-title-3 ((,class (:height 1.3))))
   `(info-title-4 ((,class (:height 1.2))))

   ;; BUTTON / LINK FACES
   `(link ((,class (:foreground "#8ac6f2" :underline t))))
   `(link-visited ((,class (:foreground "#e5786d" :underline t))))
   `(button ((,class (:background "#333333" :foreground "#f6f3e8"))))
   `(header-line ((,class (:background "#303030" :foreground "#e7f6da"))))

   ;; LINE NUMBERS
   `(line-number ((,class (:inherit default :foreground "#545454"))))
   `(line-number-current-line ((,class (:inherit line-number :foreground "#f6f3e8"))))

   ;; LINUM-MODE
   `(linum ((,class (:foreground ,lnum :background ,bg2 :inherit default))))

   ;; LINUM-RELATIVE
   `(linum-relative-current-face ((,class (:foreground ,comp))))

   ;; TABBAR
   `(tabbar-button ((,class (:foreground, black))))
   `(tabbar-button-highlight ((,class (:inherit tabbar-default))))
   `(tabbar-default ((,class (:background ,bg1 :foreground ,head1 :height 0.9))))
   `(tabbar-highlight ((,class (:underline t))))
   `(tabbar-selected ((,class (:inherit tabbar-default :foreground ,func :weight bold))))
   `(tabbar-selected-modified ((,class (:inherit tabbar-default :foreground ,red :weight bold))))
   `(tabbar-separator ((,class (:inherit tabbar-default))))
   `(tabbar-unselected ((,class (:inherit tabbar-default :background ,bg1 :slant italic :weight light))))
   `(tabbar-unselected-modified ((,class (:inherit tabbar-unselected :background ,bg1 :foreground ,red))))

   ;; TAB-BAR-MODE
   `(tab-bar ((,class (:foreground ,base :background ,bg1))))
   `(tab-bar-tab ((,class (:foreground ,base :background ,bg1 :weight bold))))
   `(tab-bar-tab-inactive ((,class (:foreground ,base-dim :background ,bg2 :weight light))))

   ;; TAB-LINE-MODE
   `(tab-line ((,class (:foreground ,base :background ,bg1))))
   `(tab-line-tab-current ((,class (:foreground ,base :background ,bg1 :weight bold))))
   `(tab-line-tab-inactive ((,class (:foreground ,base-dim :background ,bg2 :weight light))))

   ;; TERM
   `(term ((,class (:foreground ,base :background ,bg1))))
   `(term-color-black ((,class (:foreground ,black :background ,black))))
   `(term-color-blue ((,class (:foreground ,blue :background ,blue))))
   `(term-color-cyan ((,class (:foreground ,cyan :background ,cyan))))
   `(term-color-green ((,class (:foreground ,green :background ,green))))
   `(term-color-magenta ((,class (:foreground ,magenta :background ,magenta))))
   `(term-color-red ((,class (:foreground ,red :background ,red))))
   `(term-color-white ((,class (:foreground ,base :background ,base))))
   `(term-color-yellow ((,class (:foreground ,yellow :background ,yellow))))

   ;; ESHELL
   `(eshell-ls-backup ((,class (:foreground ,bg-alt))))
   `(eshell-ls-directory ((,class (:foreground ,blue))))
   `(eshell-ls-executable ((,class (:foreground ,green))))
   `(eshell-ls-symlink ((,class (:foreground ,yellow))))

   ;; IDO
   `(ido-first-match ((,class (:foreground ,green :bold nil))))
   `(ido-only-match ((,class (:foreground ,cyan :weight bold))))
   `(ido-subdir ((,class (:foreground ,keyword-fl :weight bold))))
   `(ido-vertical-match-face ((,class (:foreground ,const :underline nil))))
   `(ido-indicator ((,class (:foreground ,yellow :background ,red))))

   ;; HELM
   `(helm-bookmark-directory ((,class (:inherit helm-ff-directory))))
   `(helm-bookmark-file ((,class (:foreground ,base))))
   `(helm-bookmark-gnus ((,class (:foreground ,comp))))
   `(helm-bookmark-info ((,class (:foreground ,comp))))
   `(helm-bookmark-man ((,class (:foreground ,comp))))
   `(helm-bookmark-w3m ((,class (:foreground ,comp))))
   `(helm-buffer-directory ((,class (:foreground ,base :background ,bg1))))
   `(helm-buffer-file ((,class (:foreground ,base :background ,bg1))))
   `(helm-buffer-not-saved ((,class (:foreground ,comp :background ,bg1))))
   `(helm-buffer-process ((,class (:foreground ,keyword :background ,bg1))))
   `(helm-buffer-saved-out ((,class (:foreground ,base :background ,bg1))))
   `(helm-buffer-size ((,class (:foreground ,base :background ,bg1))))
   `(helm-candidate-number ((,class (:background ,bg1 :foreground ,keyword :inherit bold))))
   `(helm-ff-directory ((,class (:foreground ,keyword :background ,bg1 :inherit bold))))
   `(helm-ff-dotted-directory ((,class (:foreground ,keyword :background ,bg1 :inherit bold))))
   `(helm-ff-dotted-symlink-directory ((,class (:foreground ,cyan :background ,bg1 :inherit bold))))
   `(helm-ff-executable ((,class (:foreground ,suc :background ,bg1 :weight normal))))
   `(helm-ff-file ((,class (:foreground ,base :background ,bg1 :weight normal))))
   `(helm-ff-invalid-symlink ((,class (:foreground ,red :background ,bg1 :inherit bold))))
   `(helm-ff-prefix ((,class (:foreground ,bg1 :background ,keyword :weight normal))))
   `(helm-ff-symlink ((,class (:foreground ,cyan :background ,bg1 :inherit bold))))
   `(helm-grep-cmd-line ((,class (:foreground ,base :background ,bg1))))
   `(helm-grep-file ((,class (:foreground ,base :background ,bg1))))
   `(helm-grep-finish ((,class (:foreground ,base :background ,bg1))))
   `(helm-grep-lineno ((,class (:foreground ,type :background ,bg1 :inherit bold))))
   `(helm-grep-match ((,class (:foreground unspecified :background unspecified :inherit helm-match))))
   `(helm-header ((,class (:foreground ,base :background ,bg1 :underline nil :box nil))))
   `(helm-header-line-left-margin ((,class (:foreground ,keyword :background unspecified))))
   `(helm-match ((,class (:background ,head1-bg :foreground ,head1))))
   `(helm-match-item ((,class (:background ,head1-bg :foreground ,head1))))
   `(helm-moccur-buffer ((,class (:foreground ,var :background ,bg1))))
   `(helm-selection ((,class (:background ,highlight))))
   `(helm-selection-line ((,class (:background ,bg2))))
   `(helm-separator ((,class (:foreground ,comp :background ,bg1))))
   `(helm-source-header ((,class (:background ,comp :foreground ,bg1 :inherit bold))))
   `(helm-time-zone-current ((,class (:foreground ,keyword :background ,bg1))))
   `(helm-time-zone-home ((,class (:foreground ,comp :background ,bg1))))
   `(helm-visible-mark ((,class (:foreground ,keyword :background ,bg3))))

   ;; WEB-MODE
   `(web-mode-builtin-face ((,class (:inherit ,font-lock-builtin-face))))
   `(web-mode-comment-face ((,class (:inherit ,font-lock-comment-face))))
   `(web-mode-constant-face ((,class (:inherit ,font-lock-constant-face))))
   `(web-mode-current-element-highlight-face ((,class (:background ,bg3))))
   `(web-mode-doctype-face ((,class (:inherit ,font-lock-comment-face))))
   `(web-mode-function-name-face ((,class (:inherit ,font-lock-function-name-face))))
   `(web-mode-html-attr-name-face ((,class (:foreground ,func))))
   `(web-mode-html-attr-value-face ((,class (:foreground ,keyword))))
   `(web-mode-html-tag-face ((,class (:foreground ,keyword))))
   `(web-mode-keyword-face ((,class (:foreground ,keyword))))
   `(web-mode-string-face ((,class (:foreground ,str))))
   `(web-mode-symbol-face ((,class (:foreground ,type))))
   `(web-mode-type-face ((,class (:inherit ,font-lock-type-face))))
   `(web-mode-warning-face ((,class (:inherit ,font-lock-warning-face))))

   ;; WHICH-FUNCTION-MODE
   `(which-func ((,class (:foreground ,func))))

   ;; WHITESPACE
   `(whitespace-space ((,class (:background unspecified :weight bold :foreground "#505050"))))
   `(whitespace-tab ((,class (:background unspecified :weight bold :foreground "#505050"))))
   `(whitespace-hspace ((,class (:background unspecified :foreground "#453d41"))))
   `(whitespace-line ((,class (:background "#453d41" :foreground "#e5786d"))))
   `(whitespace-newline ((,class (:background unspecified :foreground "#453d41"))))
   `(whitespace-trailing ((,class (:background "#e5786d" :weight bold :foreground "#e5786d"))))
   `(whitespace-empty ((,class (:background "#ddaa6f" :foreground "#ddaa6f"))))
   `(whitespace-indentation ((,class (:background "#ddaa6f" :foreground "#e5786d"))))
   `(whitespace-space-after-tab ((,class (:background "#ddaa6f" :foreground "#ddaa6f"))))
   `(whitespace-space-before-tab ((,class (:background "#ccaa8f" :foreground "#ccaa8f"))))

   ;; DIFF
   `(diff-added ((,class :background unspecified :foreground ,green :extend t)))
   `(diff-changed ((,class :background unspecified :foreground ,blue)))
   `(diff-header ((,class :background ,cblk-ln-bg :foreground ,cblk :extend t)))
   `(diff-file-header ((,class :background ,cblk-ln-bg :foreground ,func :extend t)))
   `(diff-indicator-added ((,class :background unspecified :foreground ,green :extend t)))
   `(diff-indicator-changed ((,class :background unspecified :foreground ,blue)))
   `(diff-indicator-removed ((,class :background unspecified :foreground ,red)))
   `(diff-refine-added ((,class :background ,green :foreground ,bg1)))
   `(diff-refine-changed ((,class :background ,blue :foreground ,bg1)))
   `(diff-refine-removed ((,class :background ,red :foreground ,bg1)))
   `(diff-removed ((,class :background unspecified :foreground ,red :extend t)))

   ;; DIFF-HL
   `(diff-hl-insert ((,class :background ,green :foreground ,green)))
   `(diff-hl-delete ((,class :background ,red :foreground ,red)))
   `(diff-hl-change ((,class :background ,blue :foreground ,blue)))

   ;; EDIFF
   `(ediff-current-diff-A ((,class(:background ,red-bg :foreground ,red :extend t))))
   `(ediff-current-diff-Ancestor ((,class(:background ,aqua-bg :foreground ,aqua :extend t))))
   `(ediff-current-diff-B ((,class(:background ,green-bg :foreground ,green :extend t))))
   `(ediff-current-diff-C ((,class(:background ,blue-bg :foreground ,blue :extend t))))
   `(ediff-even-diff-A ((,class(:background ,bg3 :extend t))))
   `(ediff-even-diff-Ancestor ((,class(:background ,bg3 :extend t))))
   `(ediff-even-diff-B ((,class(:background ,bg3 :extend t))))
   `(ediff-even-diff-C ((,class(:background ,bg3 :extend t))))
   `(ediff-fine-diff-A ((,class(:background ,red :foreground ,bg1 :extend t))))
   `(ediff-fine-diff-Ancestor ((,class(:background unspecified :inherit bold :extend t))))
   `(ediff-fine-diff-B ((,class(:background ,green :foreground ,bg1))))
   `(ediff-fine-diff-C ((,class(:background ,blue :foreground ,bg1))))
   `(ediff-odd-diff-A ((,class(:background ,bg4 :extend t))))
   `(ediff-odd-diff-Ancestor ((,class(:background ,bg4 :extend t))))
   `(ediff-odd-diff-B ((,class(:background ,bg4 :extend t))))
   `(ediff-odd-diff-C ((,class(:background ,bg4 :extend t))))

   ;; DIRED
   `(dired-directory ((,class (:foreground ,keyword-fl :background ,bg1 :inherit bold))))
   `(dired-flagged ((,class (:foreground ,red))))
   `(dired-header ((,class (:foreground ,meta :inherit bold))))
   `(dired-ignored ((,class (:inherit shadow))))
   `(dired-mark ((,class (:foreground ,comp :inherit bold))))
   `(dired-marked ((,class (:foreground ,magenta :inherit bold))))
   `(dired-perm-write ((,class (:foreground ,keyword :underline t))))
   `(dired-symlink ((,class (:foreground ,cyan :background ,bg1 :inherit bold))))
   `(dired-warning ((,class (:foreground ,war))))

   ;; GNUS FACES
   `(gnus-group-news-1 ((,class (:weight bold :foreground "#95e454"))))
   `(gnus-group-news-1-low ((,class (:foreground "#95e454"))))
   `(gnus-group-news-2 ((,class (:weight bold :foreground "#cae682"))))
   `(gnus-group-news-2-low ((,class (:foreground "#cae682"))))
   `(gnus-group-news-3 ((,class (:weight bold :foreground "#ccaa8f"))))
   `(gnus-group-news-3-low ((,class (:foreground "#ccaa8f"))))
   `(gnus-group-news-4 ((,class (:weight bold :foreground "#99968b"))))
   `(gnus-group-news-4-low ((,class (:foreground "#99968b"))))
   `(gnus-group-news-5 ((,class (:weight bold :foreground "#cae682"))))
   `(gnus-group-news-5-low ((,class (:foreground "#cae682"))))
   `(gnus-group-news-low ((,class (:foreground "#99968b"))))
   `(gnus-group-mail-1 ((,class (:weight bold :foreground "#95e454"))))
   `(gnus-group-mail-1-low ((,class (:foreground "#95e454"))))
   `(gnus-group-mail-2 ((,class (:weight bold :foreground "#cae682"))))
   `(gnus-group-mail-2-low ((,class (:foreground "#cae682"))))
   `(gnus-group-mail-3 ((,class (:weight bold :foreground "#ccaa8f"))))
   `(gnus-group-mail-3-low ((,class (:foreground "#ccaa8f"))))
   `(gnus-group-mail-low ((,class (:foreground "#99968b"))))
   `(gnus-header-content ((,class (:foreground "#8ac6f2"))))
   `(gnus-header-from ((,class (:weight bold :foreground "#95e454"))))
   `(gnus-header-subject ((,class (:foreground "#cae682"))))
   `(gnus-header-name ((,class (:foreground "#8ac6f2"))))
   `(gnus-header-newsgroups ((,class (:foreground "#cae682"))))

   ;; MESSAGE FACES
   `(message-header-name ((,class (:foreground "#8ac6f2" :weight bold))))
   `(message-header-cc ((,class (:foreground "#95e454"))))
   `(message-header-other ((,class (:foreground "#95e454"))))
   `(message-header-subject ((,class (:foreground "#cae682"))))
   `(message-header-to ((,class (:foreground "#cae682"))))
   `(message-cited-text ((,class (:foreground "#99968b"))))
   `(message-separator ((,class (:foreground "#e5786d" :weight bold))))

   ;; MAGIT
   `(magit-blame-culprit ((,class :background ,yellow-bg :foreground ,yellow)))
   `(magit-blame-date    ((,class :background ,yellow-bg :foreground ,green)))
   `(magit-blame-hash    ((,class :background ,yellow-bg :foreground ,func)))
   `(magit-blame-header  ((,class :background ,yellow-bg :foreground ,green)))
   `(magit-blame-heading ((,class :background ,yellow-bg :foreground ,green)))
   `(magit-blame-name    ((,class :background ,yellow-bg :foreground ,yellow)))
   `(magit-blame-sha1    ((,class :background ,yellow-bg :foreground ,func)))
   `(magit-blame-subject ((,class :background ,yellow-bg :foreground ,yellow)))
   `(magit-blame-summary ((,class :background ,yellow-bg :foreground ,yellow :extend t)))
   `(magit-blame-time    ((,class :background ,yellow-bg :foreground ,green)))
   `(magit-branch ((,class (:foreground ,const :inherit bold))))
   `(magit-branch-current ((,class (:background ,blue-bg :foreground ,blue :inherit bold :box t))))
   `(magit-branch-local ((,class (:background ,blue-bg :foreground ,blue :inherit bold))))
   `(magit-branch-remote ((,class (:background ,aqua-bg :foreground ,aqua :inherit bold))))
   `(magit-diff-context-highlight ((,class (:background ,bg2 :foreground ,base :extend t))))
   `(magit-diff-hunk-heading ((,class (:background ,ttip-bg :foreground ,ttip :extend t))))
   `(magit-diff-hunk-heading-highlight ((,class (:background ,ttip-sl :foreground ,base :extend t))))
   `(magit-hash ((,class (:foreground ,var))))
   `(magit-hunk-heading ((,class (:background ,bg3 :extend t))))
   `(magit-hunk-heading-highlight ((,class (:background ,bg3 :extend t))))
   `(magit-item-highlight ((,class :background ,bg2 :extend t)))
   `(magit-log-author ((,class (:foreground ,func))))
   `(magit-log-head-label-head ((,class (:background ,yellow :foreground ,bg1 :inherit bold))))
   `(magit-log-head-label-local ((,class (:background ,keyword :foreground ,bg1 :inherit bold))))
   `(magit-log-head-label-remote ((,class (:background ,suc :foreground ,bg1 :inherit bold))))
   `(magit-log-head-label-tags ((,class (:background ,magenta :foreground ,bg1 :inherit bold))))
   `(magit-log-head-label-wip ((,class (:background ,cyan :foreground ,bg1 :inherit bold))))
   `(magit-log-sha1 ((,class (:foreground ,str))))
   `(magit-process-ng ((,class (:foreground ,war :inherit bold))))
   `(magit-process-ok ((,class (:foreground ,func :inherit bold))))
   `(magit-reflog-amend ((,class (:foreground ,magenta))))
   `(magit-reflog-checkout ((,class (:foreground ,blue))))
   `(magit-reflog-cherry-pick ((,class (:foreground ,green))))
   `(magit-reflog-commit ((,class (:foreground ,green))))
   `(magit-reflog-merge ((,class (:foreground ,green))))
   `(magit-reflog-other ((,class (:foreground ,cyan))))
   `(magit-reflog-rebase ((,class (:foreground ,magenta))))
   `(magit-reflog-remote ((,class (:foreground ,cyan))))
   `(magit-reflog-reset ((,class (:foreground ,red))))
   `(magit-section-heading ((,class (:foreground ,keyword :inherit bold :extend t))))
   `(magit-section-highlight ((,class (:background ,bg2 :extend t))))
   `(magit-section-title ((,class (:background ,bg1 :foreground ,keyword :inherit bold))))

   ;; SMERGE
   `(smerge-base ((,class (:background ,yellow-bg :extend t))))
   `(smerge-markers ((,class (:background ,ttip-bg :foreground ,ttip :extend t))))
   `(smerge-mine ((,class (:background ,red-bg))))
   `(smerge-other ((,class (:background ,green-bg))))
   `(smerge-refined-added ((,class (:background ,green-bg-s :foreground ,green))))
   `(smerge-refined-changed ((,class (:background ,blue-bg-s :foreground ,blue))))
   `(smerge-refined-removed ((,class (:background ,red-bg-s :foreground ,red))))

   ;; MAN
   `(Man-overstrike ((,class (:foreground ,head1 :inherit bold))))
   `(Man-reverse ((,class (:foreground ,highlight))))
   `(Man-underline ((,class (:foreground ,comp :underline t))))

   ;; HL-TODO
   `(hl-todo-keyword-faces '(("TODO"        . ,war)
                             ("NEXT"        . ,war)
                             ("THEM"        . ,cyan)
                             ("PROG"        . ,blue)
                             ("OKAY"        . ,blue)
                             ("DONT"        . ,red)
                             ("FAIL"        . ,red)
                             ("DONE"        . ,suc)
                             ("NOTE"        . ,yellow)
                             ("KLUDGE"      . ,yellow)
                             ("HACK"        . ,yellow)
                             ("TEMP"        . ,yellow)
                             ("FIXME"       . ,war)
                             ("XXX+"        . ,war)
                             ("\\?\\?\\?+"  . ,war)))

   ;; ANSI colors
   `(ansi-color-black ((,class (:background "#242424" :foreground "#242424"))))
   `(ansi-color-red ((,class (:background "#b85149" :foreground "#b85149"))))
   `(ansi-color-green ((,class (:background "#92a65e" :foreground "#92a65e"))))
   `(ansi-color-yellow ((,class (:background "#ccaa8f" :foreground "#ccaa8f"))))
   `(ansi-color-blue ((,class (:background "#5b98c2" :foreground "#5b98c2"))))
   `(ansi-color-magenta ((,class (:background "#64619a" :foreground "#64619a"))))
   `(ansi-color-cyan ((,class (:background "#3f9f9e" :foreground "#3f9f9e"))))
   `(ansi-color-white ((,class (:background "#f6f3e8" :foreground "#f6f3e8"))))
   `(ansi-color-bright-black ((,class (:background "#444444" :foreground "#444444"))))
   `(ansi-color-bright-red ((,class (:background "#e5786d" :foreground "#e5786d"))))
   `(ansi-color-bright-green ((,class (:background "#95e454" :foreground "#95e454"))))
   `(ansi-color-bright-yellow ((,class (:background "#edc4a3" :foreground "#edc4a3"))))
   `(ansi-color-bright-blue ((,class (:background "#8ac6f2" :foreground "#8ac6f2"))))
   `(ansi-color-bright-magenta ((,class (:background "#a6a1de" :foreground "#a6a1de"))))
   `(ansi-color-bright-cyan ((,class (:background "#70cecc" :foreground "#70cecc"))))
   `(ansi-color-bright-white ((,class (:background "#ffffff" :foreground "#ffffff"))))))

(provide-theme 'wombat-pspk)

;;; wombat-pspk-theme.el ends here
