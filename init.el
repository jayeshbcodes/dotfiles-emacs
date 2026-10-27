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
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(setq-default indent-tabs-mode nil)
(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)

;; Mouse in terminal Emacs (-nw): click to switch window/move point, drag a
;; mode line or divider to resize, wheel to scroll. Without this the
;; terminal keeps all mouse events to itself. To select text with the
;; terminal's own selection instead, hold Option (iTerm2) or Fn (Terminal.app).
(xterm-mouse-mode 1)
(mouse-wheel-mode 1)

;; Edit server: lets other programs open files in this Emacs via
;; `emacsclient -n FILE` (e.g. `rustlings --edit-cmd "emacsclient -n"`).
;; Only the first Emacs started becomes the server; later ones skip it.
(require 'server)
(unless (server-running-p) (server-start))

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

;; rust-viz: inline memory/ownership annotations (allocs, moves, borrows,
;; drops) on each line. C-c C-v r annotate (also re-runs on save),
;; C-c C-v s step through (n/p/g/G/q), C-c C-v c clear.
;; Binary: `cargo install --path ~/rust-viz` — re-run after pulling updates.
(use-package rust-viz
  :ensure nil
  :load-path "~/rust-viz/emacs"
  :hook (rust-mode . rust-viz-mode)
  :custom
  ;; Absolute path: a GUI Emacs launched from the Dock doesn't inherit the
  ;; shell's PATH, so ~/.cargo/bin may not be on `exec-path'.
  (rust-viz-executable (expand-file-name "~/.cargo/bin/rust-viz")))

;;; Markdown -------------------------------------------------------------------
(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode) ; gfm-mode adds GitHub table/fence support
  :bind (:map markdown-mode-map
              ("<f6>" . markdown-live-preview-mode))) ; gfm-mode inherits this map

;;; TidyBoard -------------------------------------------------------------------
;; Idea + task board: ~/tideaBoard/board.org (Inbox / In Progress / Finished),
;; one directory (git repo or worktree) per item under ~/tideaBoard/{tasks,ideas}/.
(use-package tidyboard
  :ensure nil
  :load-path "~/tideaBoard"
  :commands (tidy-board tidy-side tidy-new)
  :bind-keymap ("C-c t" . tidy-map))
