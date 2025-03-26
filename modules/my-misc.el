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

;; git

(use-package magit
  :ensure t)

;; appearance

;; https://protesilaos.com/emacs/modus-themes#h:e979734c-a9e1-4373-9365-0f2cd36107b8
;;; For packaged versions which must use `require'.
(use-package modus-themes
  :defer nil ;; necessary since ":bind" implies "defer t"
  :bind ("<f5>" . modus-themes-toggle)
  ;; I prefer this warmer palette; can't use ":custom" since it relies on a package var
  :config (setq modus-themes-common-palette-overrides modus-themes-preset-overrides-warmer)
  ;; Load the theme of your choice.
  (load-theme 'modus-vivendi :no-confirm)
  (define-key global-map (kbd "<f5>") #'modus-themes-toggle))

(provide 'my-misc)
;;; my-misc.el ends here
