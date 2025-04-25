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

;; https://protesilaos.com/emacs/denote
(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep))
  :config
  (setq denote-directory (expand-file-name "notes" my-org-directory))

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have, for example, a literal
  ;; "[D]" followed by the file's title.  Read the doc string of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1))


(provide 'my-org)
;;; my-org.el ends here
