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
  ;; consider adding more cape functions
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file))
(use-package consult
  :init (setq completion-in-region-function #'consult-completion-in-region))
(use-package corfu
  :init (global-corfu-mode 1)
  :init (global-completion-preview-mode)
  :custom (corfu-cycle t)        ; Allows cycling through candidates
  :custom (corfu-auto t)         ; Enable auto completion
  :custom (corfu-auto-prefix 2)  ; Complete with less prefix keys
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
  :init (marginalia-mode 1))
(use-package vertico
  :init (vertico-mode 1))

(use-package orderless
  :init
   ;; Tune the global completion style settings to your liking!
   ;; This affects the minibuffer and non-lsp completion at point.
   (setq completion-styles '(orderless partial-completion basic)))

(provide 'my-completion)
;;; my-completion.el ends here
