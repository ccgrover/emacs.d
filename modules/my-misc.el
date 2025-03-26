;;; my-misc.el --- <Quick desc> -*- lexical-binding: t; -*-

;;; Commentary:

;;  My miscellaneous items; mostly adjusting Emacs defaults

;;; Code:

;; backup behavior

(setq backup-directory-alist `(("." . "~/.file_backups")))
(setq backup-by-copying-when-linked t)

;; git

(use-package magit)

;; appearance

(use-package modus-themes
  :config (load-theme 'modus-vivendi t)
  (enable-theme 'modus-vivendi))

;; https://protesilaos.com/emacs/modus-themes#h:e979734c-a9e1-4373-9365-0f2cd36107b8
(use-package modus-themes
  :bind ("<f5>" . modus-themes-toggle)
  :config (load-theme 'modus-vivendi t))

(provide 'my-misc)
;;; my-misc.el ends here
