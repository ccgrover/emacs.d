;;; my-misc.el --- <Quick desc> -*- lexical-binding: t; -*-

;;; Commentary:

;;  My miscellaneous items; mostly adjusting Emacs defaults

;;; Code:

;; TODO move this

;;; Setup Emacs Lisp Package Archives (ELPAs)
;; where to get packages to install

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
