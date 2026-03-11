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

(provide 'my-completion)
;;; my-completion.el ends here
