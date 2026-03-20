;;; my-completion.el --- Completion setup -*- lexical-binding: t; -*-

;;; Commentary:

;;  "Complesius" support

;;; Code:

;; Add extensions

;; ========== VERTICO ==========

;; Vertico is a minibuffer-based completion UI

(use-package vertico
  :custom
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.

(use-package savehist
  :init
  (savehist-mode))

;; ========== MARGINALIA ==========

;; Marginalia adds rich annotations in the minibuffer

(use-package marginalia
  :init
  (marginalia-mode))

;; ========== CORFU ==========

(use-package corfu
  :init (global-corfu-mode 1)
  ;; global-completion-preview-mode disabled for performance
  :custom (corfu-cycle t)        ; Allows cycling through candidates
  :custom (corfu-auto t)         ; Enable auto completion
  :custom (corfu-auto-prefix 3)  ; minimum number of characters
  :custom (corfu-auto-delay 0.2) ; delay before completion candidates appear
  )

;; Add icons to Corfu completions
(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; Use corfu face
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; Add documentation popups to Corfu
(use-package corfu-doc
  :after corfu
  :hook (corfu-mode . corfu-doc-mode)
  :custom
  (corfu-doc-delay 0.5)
  (corfu-doc-max-width 70)
  (corfu-doc-max-height 20)
  :config
  ;; Use C-c d to toggle documentation popup manually
  (define-key corfu-map (kbd "C-c d") #'corfu-doc-toggle))

(use-package cape)

(use-package orderless
  :init
  ;; Tune the global completion style settings to your liking!
  ;; This affects the minibuffer and non-lsp completion at point.
  (setq completion-styles '(orderless partial-completion basic)
        completion-category-defaults nil
        completion-category-overrides nil))

(provide 'my-completion)
;;; my-completion.el ends here
