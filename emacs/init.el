;;; init.el --- minimal Emacs setup with the openSUSE theme -*- lexical-binding: t; -*-
;; Built-ins only: no packages are downloaded.

;;; Theme
(add-to-list 'custom-theme-load-path (file-name-directory (or load-file-name buffer-file-name)))
(load-theme 'opensuse t)

;;; Font (matches foot)
(set-face-attribute 'default nil :family "Source Code Pro" :height 110)

;;; Look
(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function #'ignore)
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(add-to-list 'default-frame-alist '(internal-border-width . 12))
(add-to-list 'default-frame-alist '(alpha-background . 95)) ; Emacs 29+, pgtk
(column-number-mode 1)
(global-hl-line-mode 1)
(show-paren-mode 1)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;;; Behavior
(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 80)
(setq make-backup-files nil
      auto-save-default nil
      use-short-answers t
      scroll-conservatively 101
      custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))
(electric-pair-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(global-auto-revert-mode 1)

;;; Completion (built-in, Emacs 28+)
(fido-vertical-mode 1)

;;; init.el ends here
