;; -*- lexical-binding: t; -*-
;;; Package setup ------------------------------------------------------------
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                          ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;;; Sane defaults --------------------------------------------------------------
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(fset 'yes-or-no-p 'y-or-n-p)

;; Claude Code edits files on disk outside Emacs; keep open buffers in sync.
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(show-paren-mode 1)
(electric-pair-mode 1)
(column-number-mode 1)
(setq-default indent-tabs-mode nil)
(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)

;;; Theme ----------------------------------------------------------------------
;; modus-themes is built into Emacs 28+, no external package needed.
(use-package modus-themes
  :ensure nil
  :init (load-theme 'modus-vivendi t)
  :bind ("<f5>" . modus-themes-toggle)) ; switch dark/light

;;; Discoverability -------------------------------------------------------------
;; Pops up available next keys a moment after any prefix key (C-x, C-c, Magit's
;; c/b/l/etc.) so you never have to hold a key sequence in your head.
(use-package which-key
  :config (which-key-mode 1))

;;; Git / diff review -----------------------------------------------------------
(use-package magit
  :bind ("C-x g" . magit-status))

;;; Rust --------------------------------------------------------------------
(use-package rust-mode
  :custom (rust-format-on-save t))

;; Eglot ships with almost no default keybindings (upstream deliberately
;; leaves that to the user) so bind the ones actually used day-to-day.
(use-package eglot
  :ensure nil ; built-in since Emacs 29
  :hook (rust-mode . eglot-ensure)
  :bind (:map eglot-mode-map
              ("C-c C-a" . eglot-code-actions)
              ("C-c C-r" . eglot-rename)))

;; Flymake's next/prev-error commands are also menu-only by default.
(use-package flymake
  :ensure nil ; built-in
  :bind (:map flymake-mode-map
              ("M-n" . flymake-goto-next-error)
              ("M-p" . flymake-goto-prev-error)))

;; Auto-popup completions as you type, fed by eglot's completion-at-point.
;; (corfu is the modern alternative but needs an extra package to render in
;; a terminal; company works in both GUI and -nw out of the box.)
(use-package company
  :hook (rust-mode . company-mode)
  :bind (:map company-mode-map
              ("M-/" . company-complete)) ; manual trigger if the popup didn't fire
  :custom
  (company-idle-delay 0.2)
  (company-minimum-prefix-length 1))

;;; Markdown -------------------------------------------------------------------
(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode) ; gfm-mode adds GitHub table/fence support
  :bind (:map markdown-mode-map
              ("<f6>" . markdown-live-preview-mode))) ; gfm-mode inherits this map
