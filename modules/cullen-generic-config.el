;;; cullen-generic-config.el --- Generic config -*- lexical-binding: t; -*-

;;; Commentary:

;;  My generic config items

;;; Code:

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

;; tweak this for responsiveness
(customize-set-variable 'corfu-auto-delay 0.25)

(define-prefix-command 'cullen-files-key-map)
(keymap-set 'cullen-files-key-map "e" 'visit-emacs-init-file)
(keymap-set 'cullen-files-key-map "b" 'visit-bashrc-file)
(keymap-set 'cullen-files-key-map "z" 'visit-zshrc-file)
(keymap-set 'cullen-files-key-map "j" 'visit-java-config-file)

(keymap-global-set "C-c f" 'cullen-files-key-map)

(yas-global-mode)

;; tweak this for completion responsiveness
(customize-set-variable 'corfu-auto-delay 0.25)

;; https://github.com/purcell/exec-path-from-shell?tab=readme-ov-file#usage
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(provide 'cullen-generic-config)
;;; cullen-generic-config.el ends here
