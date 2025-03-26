;;; early-init.el --- (Early) init! -*- lexical-binding: t -*-
;;; Commentary:

;;  Early init stuff.

;;; Code:

;;  package setup
(require 'package)

(setq use-package-always-ensure t)

;;; Setup Emacs Lisp Package Archives (ELPAs)
;; where to get packages to install
(add-to-list 'package-archives '("stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;;  envvar for LSP performance

(setenv "LSP_USE_PLISTS" "true")

;;; _
(provide 'early-init)
;;; early-init.el ends here
