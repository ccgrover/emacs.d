;;; my-completion.el --- <Quick desc> -*- lexical-binding: t; -*-

;;; Commentary:

;;  <Commentary here>

;;; Code:

;; Add extensions
(use-package cape
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press C-c p ? to for help.
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; cape functions removed for performance - LSP provides completions
  )
(use-package consult
  :init (setq completion-in-region-function #'consult-completion-in-region))
(use-package corfu
  :init (global-corfu-mode 1)
  ;; global-completion-preview-mode disabled for performance
  :custom (corfu-cycle t)        ; Allows cycling through candidates
  :custom (corfu-auto t)         ; Enable auto completion
  :custom (corfu-auto-prefix 2)  ; Reduced for better performance
  :custom (corfu-auto-delay 0.0) ; Instant completion
  )
(use-package corfu-terminal)
(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))
(use-package marginalia
  :config (marginalia-mode 1))
(use-package vertico
  :init (vertico-mode 1)
  ;; https://github.com/oantolin/embark?tab=readme-ov-file#selecting-commands-via-completions-instead-of-key-bindings
  )

(use-package orderless
  :init
  ;; Tune the global completion style settings to your liking!
  ;; This affects the minibuffer and non-lsp completion at point.
  (setq completion-styles '(orderless partial-completion basic)))

(provide 'my-completion)
;;; my-completion.el ends here
