;;; cullen-performance-config.el --- GCMH config -*- lexical-binding: t; -*-

;;; Commentary:

;;  Config for managing performance (especially with LSP)

;;; Code:

(setq gcmh-high-cons-threshold (* 128 1024 1024))
(add-hook 'after-init-hook (lambda ()
                             (gcmh-mode)
                             (diminish 'gcmh-mode)))

(setq jit-lock-defer-time 0)

(provide 'cullen-performance-config)
;;; cullen-performance-config.el ends here
