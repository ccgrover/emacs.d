;;; my-org.el --- org-mode config -*- lexical-binding: t; -*-

;;; Commentary:

;;  org-mode configuration

;;; Code:

(setq org-agenda-files '("~/workspace/cullen-org"))
(setq org-directory    "~/workspace/cullen-org")
(setq org-default-notes-file (concat org-directory "/todo.org"))

(define-prefix-command 'cullen-org-key-map)
(keymap-set 'cullen-org-key-map "a" #'org-agenda)
(keymap-set 'cullen-org-key-map "l" #'org-todo-list)
(keymap-set 'cullen-org-key-map "c" #'org-capture)

(keymap-global-set "C-c o" 'cullen-org-key-map)

(provide 'my-org)
;;; my-org.el ends here
