;;; cullen-lsp.el --- LSP packages -*- lexical-binding: t; -*-

;;; Commentary:

;;  Generic LSP packages

;;; Code:

(use-package projectile)
(use-package flycheck
  :hook (flycheck-mode . flycheck-set-indication-mode)
  :custom (flycheck-indication-mode 'left-margin))
(use-package yasnippet
  :commands yas-global-mode)
(use-package lsp-mode
  :hook (lsp-mode . lsp-enable-which-key-integration))
(use-package hydra)
(use-package company)
(use-package lsp-ui)
(use-package which-key
  :commands which-key-mode)
(use-package lsp-java
  :hook (java-mode . lsp))
(use-package dap-mode
  :after lsp-mode
  :commands dap-auto-configure-mode)
(use-package dap-java
  :ensure nil)
(use-package helm-lsp)
(use-package helm
  :commands helm-mode)
(use-package lsp-treemacs)

(provide 'cullen-lsp)
;;; cullen-lsp.el ends here
