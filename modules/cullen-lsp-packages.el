;;; cullen-lsp-packages.el --- LSP packages -*- lexical-binding: t; -*-

;;; Commentary:

;;  Generic LSP packages

;;; Code:

(add-to-list 'package-selected-packages 'lsp-mode)
(add-to-list 'package-selected-packages 'lsp-ui)
(add-to-list 'package-selected-packages 'dap-mode)
(add-to-list 'package-selected-packages 'flycheck)

(provide 'cullen-lsp-packages)
;;; cullen-lsp-packages.el ends here
