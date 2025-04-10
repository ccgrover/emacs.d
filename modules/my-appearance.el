;;; my-appearance.el --- Emacs appearance -*- lexical-binding: t; -*-

;;; Commentary:

;;  Appearance config, e.g. fonts, colors

;;; Code:

;; display line numbers for all programming modes

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'yaml-mode-hook 'display-line-numbers-mode)
(add-hook 'yaml-ts-mode-hook 'display-line-numbers-mode)

;; themes

(use-package ef-themes
  :ensure t
  :defer nil ;; necessary since ":bind" implies "defer t"
  :bind ("<f7>" . ef-themes-rotate)
  :bind ("<f8>" . ef-themes-toggle)
  :config
  (ef-themes-select 'ef-dream))

(provide 'my-appearance)
;;; my-appearance.el ends here
