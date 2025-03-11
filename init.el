;;; init.el --- Init! -*- lexical-binding: t -*-
;;; Commentary:

;;  Init file utilizing CraftedEmacs

;;; Code:

;; set to 't' for debugging
(setq debug-on-error t)

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

;; performance config from https://github.com/purcell/emacs.d/blob/master/init.el

;; Adjust garbage collection threshold for early startup
(setq gc-cons-threshold (* 128 1024 1024))

;; Process performance tuning
(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)

;; backup behavior

(setq backup-directory-alist `(("." . "~/.file_backups")))
(setq backup-by-copying-when-linked t)

;; init CraftedEmacs
(load (expand-file-name "modules/crafted-init-config" crafted-emacs-home))

;; add packages to install
(require 'crafted-completion-packages)
(require 'crafted-ide-packages)
(require 'crafted-lisp-packages)
(require 'crafted-org-packages)
(require 'crafted-ui-packages)
(require 'crafted-writing-packages)

(require 'cullen-git-packages)
(require 'cullen-lsp-java-packages)
(require 'cullen-performance-packages)

;; no packages listed after this line will be installed
(package-install-selected-packages :noconfirm)

;; now configure the installed packages
(require 'crafted-defaults-config)
(require 'crafted-startup-config)
(require 'crafted-completion-config)
(require 'crafted-ide-config)
(require 'crafted-lisp-config)
(require 'crafted-org-config)
(require 'crafted-ui-config)
(require 'crafted-writing-config)

(require 'cullen-defaults-config)
(require 'cullen-lsp-java-config)
(require 'cullen-performance-config)

;;; _
(provide 'init)
;;; init.el ends here
