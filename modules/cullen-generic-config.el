;;; cullen-generic-config.el --- Generic config -*- lexical-binding: t; -*-

;;; Commentary:

;;  My generic config items

;;; Code:

;; backup behavior


;; shortcuts to visit common files

(defun visit-emacs-init-file ()
  "Visit Emacs init file."
  (interactive)
  (find-file user-init-file))

(defun visit-bashrc-file ()
  "Visit the .bashrc file."
  (interactive)
  (find-file "~/.bashrc"))

(defun visit-zshrc-file ()
  "Visit the .zshrc file."
  (interactive)
  (find-file "~/.zshrc"))

(defun visit-java-config-file ()
  "Visit my Emacs Java config file."
  (interactive)
  (find-file (expand-file-name "./modules/cullen-lsp-java-config.el" user-emacs-directory)))

(defun visit-tasks-file ()
  "Visit tasks file."
  (interactive)
  (find-file org-default-notes-file))

;; tweak this for responsiveness
(customize-set-variable 'corfu-auto-delay 0.25)

(define-prefix-command 'cullen-files-key-map)
(keymap-set 'cullen-files-key-map "e" 'visit-emacs-init-file)
(keymap-set 'cullen-files-key-map "b" 'visit-bashrc-file)
(keymap-set 'cullen-files-key-map "z" 'visit-zshrc-file)
(keymap-set 'cullen-files-key-map "j" 'visit-java-config-file)
(keymap-set 'cullen-files-key-map "t" 'visit-tasks-file)

(keymap-global-set "C-c f" 'cullen-files-key-map)

(yas-global-mode)

;; tweak this for completion responsiveness
(customize-set-variable 'corfu-auto-delay 0.25)

;; https://github.com/purcell/exec-path-from-shell?tab=readme-ov-file#usage
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; YAML

(add-hook 'yaml-mode-hook #'yaml-pro-mode 100)

;; appearance

(require-theme 'modus-themes)
(load-theme 'modus-vivendi :no-confirm)
(define-key global-map (kbd "<f5>") #'modus-themes-toggle)
(enable-theme 'modus-vivendi)

;; tree-sitter grammars

(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

;; _
(provide 'cullen-generic-config)
;;; cullen-generic-config.el ends here
