;;; my-python.el --- Python + LSP packages -*- lexical-binding: t; -*-

;;; Commentary:

;;  Using Python and lsp-mode

;;; Code:

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "basedpyright") ;; or basedpyright
  :hook (python-ts-mode . (lambda ()
                            (require 'lsp-pyright)
                            (lsp))))  ; or lsp-deferred

(provide 'my-python)
;;; my-python.el ends here
