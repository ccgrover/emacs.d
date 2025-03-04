;;; cullen-defaults-config.el --- Generic config -*- lexical-binding: t; -*-

;;; Commentary:

;;  My default/generic config items

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
  (find-file (expand-file-name "./modules/cullen-java-config.el" user-emacs-directory)))

(define-prefix-command 'cullen-files-key-map)
(keymap-set 'cullen-files-key-map "e" 'visit-emacs-init-file)
(keymap-set 'cullen-files-key-map "b" 'visit-bashrc-file)
(keymap-set 'cullen-files-key-map "z" 'visit-zshrc-file)
(keymap-set 'cullen-files-key-map "j" 'visit-java-config-file)

(keymap-global-set "C-c f" 'cullen-files-key-map)

(yas-global-mode)

(provide 'cullen-defaults-config)
;;; cullen-defaults-config.el ends here
