;;; cullen-generic-packages.el --- Common / generic packages -*- lexical-binding: t; -*-

;;; Commentary:

;;  Generic emacs packages

;;; Code:

;; generic utilities
(add-to-list 'package-selected-packages 'exec-path-from-shell)

;; appearance

(add-to-list 'package-selected-packages 'modus-themes)

;; yaml

(add-to-list 'package-selected-packages 'yaml)
(add-to-list 'package-selected-packages 'yaml-mode)
(add-to-list 'package-selected-packages 'yaml-pro)

(provide 'cullen-generic-packages)
;;; cullen-generic-packages.el ends here
