;;; init.el --- Init! -*- lexical-binding: t -*-
;;; Commentary:

;;  Init file utilizing CraftedEmacs

;;; Code:

;; set to 't' for debugging
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

(require 'my-misc)

;;; _
(provide 'init)
;;; init.el ends here
