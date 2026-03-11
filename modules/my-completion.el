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

;; ========== CORFU ==========

;; Vertico is a minibuffer-based completion UI

(use-package corfu
  :init (global-corfu-mode 1)
  ;; global-completion-preview-mode disabled for performance
  :custom (corfu-cycle t)        ; Allows cycling through candidates
  :custom (corfu-auto t)         ; Enable auto completion
  :custom (corfu-auto-prefix 3)  ; minimum number of characters
  :custom (corfu-auto-delay 0.2) ; delay before completion candidates appear
  )

(provide 'my-completion)
;;; my-completion.el ends here
