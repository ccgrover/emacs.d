;;; my-misc.el --- <Quick desc> -*- lexical-binding: t; -*-

;;; Commentary:

;;  My miscellaneous items; mostly adjusting Emacs defaults

;;; Code:

;; some common keybindings

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

;; yaml

(use-package yaml-mode)

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

;; fix path stuff

(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(provide 'my-misc)
;;; my-misc.el ends here
