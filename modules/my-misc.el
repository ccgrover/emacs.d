;;; my-misc.el --- <Quick desc> -*- lexical-binding: t; -*-

;;; Commentary:

;;  My miscellaneous items; mostly adjusting Emacs defaults

;;; Code:

;; some common keybindings

;; 'y' or 'n'
(setq use-short-answers t)

;; automatically revert buffers that change behind Emacs' back

(global-auto-revert-mode)

;; delete region when you type / paste something

(delete-selection-mode 1)

;; do not create lockfiles

(setq create-lockfiles nil)

;; backup behavior

(make-directory "~/.file_backups" t)
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

;; vlf - very large files

(use-package vlf)

;; mc

(use-package multiple-cursors)

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

;; clickable links!

(global-goto-address-mode 1)

;; editorconfig support globally

(use-package editorconfig
  :config
  (editorconfig-mode 1))

;; fix path stuff

(use-package exec-path-from-shell
  :config
  (dolist (var '("SNOWFLAKE_USER"))
    (add-to-list 'exec-path-from-shell-variables var))
  (exec-path-from-shell-initialize))
;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize)))

;; recipe extraction!

(use-package org-chef
  :ensure t)

(provide 'my-misc)
;;; my-misc.el ends here
