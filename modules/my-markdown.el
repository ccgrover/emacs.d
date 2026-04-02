;;; my-markdown.el --- Markdown support -*- lexical-binding: t; -*-

;;; Commentary:

;;  Using markdown-mode for docs

;;; Code:

(use-package markdown-mode
  :defer t
  :init (setq markdown-command "pandoc")
  :bind (:map markdown-mode-map
         ("C-c C-e" . markdown-do)))

(provide 'my-markdown)
;;; my-markdown.el ends here
