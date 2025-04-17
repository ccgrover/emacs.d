;;; my-misc.el --- <Quick desc> -*- lexical-binding: t; -*-

;;; Commentary:

;;  My miscellaneous items; mostly adjusting Emacs defaults

;;; Code:

;; automatically revert buffers that change behind Emacs' back

(global-auto-revert-mode)

;; do not create lockfiles

(setq create-lockfiles nil)

;; backup behavior

(setq backup-directory-alist `(("." . "~/.file_backups")))
(setq backup-by-copying-when-linked t)

;; spaces, not tabs

(setq-default indent-tabs-mode nil)

;; git

(use-package magit)

;; tree-sitter grammars

(use-package yaml-mode)
(use-package tree-sitter-langs
  :config (tree-sitter-require 'yaml))

(provide 'my-misc)
;;; my-misc.el ends here
