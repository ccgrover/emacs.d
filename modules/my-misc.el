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

;; save minibuffer history

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

;; enable repeat mode!

(repeat-mode 1)

(provide 'my-misc)
;;; my-misc.el ends here
