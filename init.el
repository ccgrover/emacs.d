;;; init.el --- Init! -*- lexical-binding: t -*-
;;; Commentary:

;;  Init file utilizing CraftedEmacs

;;; Code:

;; package setup
(require 'package)
(require 'use-package-ensure)

(add-to-list 'package-archives '("stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(customize-set-variable 'package-archive-priorities
                        '(("gnu"    . 99)   ; prefer GNU packages
                          ("nongnu" . 80)   ; use non-gnu packages if
                                            ; not found in GNU elpa
                          ("melpa"  . 70)   ; prefer most updated
                          ("stable" . 0)))  ; fall back to stable

(setq use-package-always-ensure t)

;; set to t for debugging
(setq debug-on-error nil)

;; set the location for auto-generated Customizations
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))

;; add my own custom modules to the load path
;; eval-and-compile ensures this happens at both compile-time and runtime
(eval-and-compile
  (add-to-list 'load-path (expand-file-name "modules" user-emacs-directory)))

;; Adjust garbage collection threshold for early startup
(setq gc-cons-threshold (* 128 1024 1024))

;; LOAD MY MODULES

(setq package-install-upgrade-built-in t)

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results nil)
  (auto-package-update-maybe))

;; Use gcmh for automatic GC management
(use-package gcmh
  :config
  (gcmh-mode 1))

(defgroup my-emacs nil
  "Custom variables used within this config and its modules."
  :group 'emacs
  :prefix "my-")

(require 'my-keybinds)
(require 'my-appearance)
(require 'my-completion)
(require 'my-misc)
(require 'my-org-notes)
(require 'my-org-presentations)
(require 'my-plantuml)
(require 'my-markdown)
(require 'my-lsp)
(require 'my-python)
(require 'my-llm)
(require 'my-dbt)

;; Enable downcase/upcase region commands
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;;; _
(provide 'init)
;;; init.el ends here
