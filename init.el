;;; init.el --- Init! -*- lexical-binding: t -*-
;;; Commentary:

;;  Init file utilizing CraftedEmacs

;;; Code:

;; set to t for debugging
(setq debug-on-error nil)

;; set the location for auto-generated Customizations
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))

;; add my own custom modules to the load path
(let ((modules (expand-file-name "./modules/" user-emacs-directory)))
  (when (file-directory-p modules)
    (message "adding modules to load-path: %s" modules)
    (add-to-list 'load-path modules)))

;; Adjust garbage collection threshold for early startup
(setq gc-cons-threshold (* 128 1024 1024))

;; LOAD MY MODULES

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results nil)
  (auto-package-update-maybe))

(defgroup my-emacs nil
  "Custom variables used within this config and its modules."
  :group 'emacs
  :prefix "my-")

(require 'my-appearance)
(require 'my-completion)
(require 'my-misc)
(require 'my-org-notes)
(require 'my-markdown)
(require 'my-lsp)
(require 'my-yaml)

;;; _
(provide 'init)
;;; init.el ends here
