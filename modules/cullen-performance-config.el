;;; cullen-performance-config.el --- GCMH config -*- lexical-binding: t; -*-

;;; Commentary:

;;  Config for managing performance (especially with LSP)

;;; Code:

(setq gc-cons-threshold (* 100 1024 1024)) ;; 100mb
(setq read-process-output-max (* 10 1024 1024)) ;; 10mb

(provide 'cullen-performance-config)
;;; cullen-performance-config.el ends here
