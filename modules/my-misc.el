;;; my-misc.el --- <Quick desc> -*- lexical-binding: t; -*-

;;; Commentary:

;;  My miscellaneous items; mostly adjusting Emacs defaults

;;; Code:

;; 'y' or 'n'
(setq use-short-answers t)

;; automatically revert buffers that change behind Emacs' back

(global-auto-revert-mode)

;; do not create lockfiles

(setq create-lockfiles nil)

;; backup behavior

(setq backup-directory-alist `(("." . "~/.file_backups")))
(setq backup-by-copying-when-linked t)

;; CSV support

(use-package csv-mode)

;; spaces, not tabs

(setq-default indent-tabs-mode nil)

;; aggressive indent mode for elisp
(use-package aggressive-indent
  :hook (emacs-lisp-mode . aggressive-indent-mode))

;; git

(use-package magit)

;; tree-sitter grammars

(use-package yaml-mode)
(use-package tree-sitter-langs
  :config (tree-sitter-require 'yaml))

;; mc

(use-package multiple-cursors)

;; save minibuffer history

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

;; enable repeat mode! handy for scrolling through buffers with left/right

(repeat-mode 1)

;; pesky keybindings I do not want

(global-unset-key (kbd "C-z"))     ;; minimize
(global-unset-key (kbd "C-x C-z")) ;; minimize

;; latex

(use-package auctex
  :config
  (setq TeX-auto-save t
        TeX-parse-self t))

(provide 'my-misc)
;;; my-misc.el ends here
