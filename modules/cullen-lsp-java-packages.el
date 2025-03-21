;;; cullen-lsp-java-packages.el --- My LSP Java config -*- lexical-binding: t; -*-

;;; Commentary:

;;  Packages for Java development using lsp-mode

;;; Code:

(add-to-list 'package-selected-packages 'lsp-java)
(add-to-list 'package-selected-packages 'lsp-java-boot)
(add-to-list 'package-selected-packages 'dap-java)

(provide 'cullen-lsp-java-packages)
;;; cullen-lsp-java-packages.el ends here
