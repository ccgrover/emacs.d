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
(use-package embark)
(use-package embark-consult)
(use-package marginalia
  :init (marginalia-mode))
(use-package vertico
  :init (vertico-mode))

;; https://github.com/minad/corfu/wiki#configuring-corfu-for-lsp-mode
(use-package orderless
  :init
  ;; Tune the global completion style settings to your liking!
  ;; This affects the minibuffer and non-lsp completion at point.
  (setq completion-styles '(orderless partial-completion basic)
        completion-category-defaults nil
        completion-category-overrides nil))


(provide 'my-completion)
;;; my-completion.el ends here
