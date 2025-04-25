;;; my-org.el --- org-mode config -*- lexical-binding: t; -*-

;;; Commentary:

;;  org-mode configuration

;;; Code:

(defcustom my-org-directory "~/workspace/cullen-org/"
  "Directory containing my org files."
  :type '(string)
  :group 'my-emacs)

(use-package org
  :ensure nil ; built-in
  :custom (org-directory my-org-directory)
  :custom (org-agenda-files '(".")) ;; relative to org-directory
  :custom (org-default-notes-file
           (concat org-directory "todo.org"))
  :config (org-babel-do-load-languages
           'org-babel-load-languages
           '((plantuml . t))) ; this line activates plantuml
  :config
  (define-prefix-command 'my-org-mode-map)
  (keymap-set 'my-org-mode-map "a" #'org-agenda)
  (keymap-set 'my-org-mode-map "l" #'org-todo-list)
  (keymap-set 'my-org-mode-map "c" #'org-capture)
  (keymap-global-set "C-c o" 'my-org-mode-map))

(use-package org-roam
  :custom (org-roam-directory my-org-directory)
  :config
  (setq org-roam-capture-templates
        '(("p" "Generic pages" plain
           (file "/home/cgrover/.emacs.d/templates/org-roam/pages.org")
           :target (file "pages/${slug}.org")))))

(provide 'my-org)
;;; my-org.el ends here
