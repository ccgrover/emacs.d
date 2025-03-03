;;; cullen-defaults-config.el --- Generic config -*- lexical-binding: t; -*-

;;; Commentary:

;;  My default/generic config items

;;; Code:

(defun visit-emacs-init-file ()
  "Visit Emacs init file."
  (interactive)
  (find-file user-init-file))

(defun visit-zshrc-file ()
  "Visit the .zshrc file."
  (interactive)
  (find-file "~/.zshrc"))

(define-prefix-command 'cullen-files-key-map)
(keymap-set 'cullen-files-key-map "e" 'visit-emacs-init-file)
(keymap-set 'cullen-files-key-map "z" 'visit-zshrc-file)

(keymap-global-set "C-c f" 'cullen-files-key-map)

(provide 'cullen-defaults-config)
;;; cullen-defaults-config.el ends here
