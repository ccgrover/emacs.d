;;; my-misc.el --- <Quick desc> -*- lexical-binding: t; -*-

;;; Commentary:

;;  My miscellaneous items; mostly adjusting Emacs defaults

;;; Code:

;; backup behavior

(setq backup-directory-alist `(("." . "~/.file_backups")))
(setq backup-by-copying-when-linked t)

;; appearance

(use-package modus-themes
  :bind ("<f5>" . modus-themes-toggle)
  :config (load-theme 'modus-vivendi :no-confirm))

(provide 'my-misc)
;;; my-misc.el ends here
