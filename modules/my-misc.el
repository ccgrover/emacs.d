;;; my-misc.el --- <Quick desc> -*- lexical-binding: t; -*-

;;; Commentary:

;;  My miscellaneous items; mostly adjusting Emacs defaults

;;; Code:

;; TODO move this

;;; Setup Emacs Lisp Package Archives (ELPAs)
;; where to get packages to install

;; backup behavior

(setq backup-directory-alist `(("." . "~/.file_backups")))
(setq backup-by-copying-when-linked t)

;; spaces, not tabs

(setq-default indent-tabs-mode nil)

;; display line numbers for all programming modes

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; git

(use-package magit)

;; appearance

;; https://protesilaos.com/emacs/modus-themes#h:e979734c-a9e1-4373-9365-0f2cd36107b8
;;; For packaged versions which must use `require'.
(use-package modus-themes
  :defer nil ;; necessary since ":bind" implies "defer t"
  :bind ("<f5>" . modus-themes-toggle)
  ;; I prefer this warmer palette; can't use ":custom" since it relies on a package var
  :config (setq modus-themes-common-palette-overrides modus-themes-preset-overrides-warmer)
  ;; Load the theme of your choice.
  (load-theme 'modus-vivendi :no-confirm)
  (define-key global-map (kbd "<f5>") #'modus-themes-toggle))

;; tree-sitter grammars

(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (java "https://github.com/tree-sitter/tree-sitter-java" "master" "src")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(provide 'my-misc)
;;; my-misc.el ends here
