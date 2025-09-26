;;; my-llm.el --- LLM packages -*- lexical-binding: t; -*-

;;; Commentary:

;;  Packages & config for LLM files

;;; Code:

(use-package gptel
  :config
  (gptel-make-anthropic "Claude" :stream t)
  (setq gptel-backend (gptel-make-anthropic "Claude")))

(provide 'my-llm)
;;; my-llm.el ends here
