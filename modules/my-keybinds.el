;;; my-keybinds.el --- Keybinds support -*- lexical-binding: t; -*-

;;; Commentary:

;;  Common / utility key bindings not associated with any explicit package

;;; Code:

(defun my/kill-current-buffer ()
  "Kill the currently buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(keymap-global-set "C-c k" 'my/kill-current-buffer)

(provide 'my-keybinds)
;;; my-keybinds.el ends here
