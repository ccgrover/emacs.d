;;; cullen-lsp-config.el --- <Quick desc> -*- lexical-binding: t; -*-

;;; Commentary:

;;  <Commentary here>

;;; Code:

;;  Generic DAP config

(dap-auto-configure-mode)

;; where Flycheck shows errors

(setq-default flycheck-indication-mode 'left-margin)
(add-hook 'flycheck-mode-hook #'flycheck-set-indication-mode)

(provide 'cullen-lsp-config)
;;; cullen-lsp-config.el ends here
