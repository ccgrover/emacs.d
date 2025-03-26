;;; early-init.el --- (Early) init! -*- lexical-binding: t -*-
;;; Commentary:

;;  Early init stuff. Mostly taken from the CraftedEmacs early-init module

;;; Code:

;;  envvar for LSP performance
(setenv "LSP_USE_PLISTS" "true")

;; package setup

(require 'package)

(add-to-list 'package-archives '("stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(customize-set-variable 'package-archive-priorities
                        '(("gnu"    . 99)   ; prefer GNU packages
                          ("nongnu" . 80)   ; use non-gnu packages if
                                            ; not found in GNU elpa
                          ("stable" . 70)   ; prefer "released" versions
                                            ; from melpa
                          ("melpa"  . 0)))  ; if all else fails, get it
				            ; from melpa

(package-initialize)
(package-refresh-contents)
(setq use-package-always-ensure t)

;;; _
(provide 'early-init)
;;; early-init.el ends here
