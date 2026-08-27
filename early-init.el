;; -*- lexical-binding: t; -*-
;; Strip UI chrome before the frame first paints (avoids flash of toolbar/menu).
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(setq package-enable-at-startup nil) ; we call (package-initialize) ourselves in init.el
