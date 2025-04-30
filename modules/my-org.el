;;; my-org.el --- org-mode config -*- lexical-binding: t; -*-

;;; Commentary:

;;  Packages for note-taking, ft org-mode.

;;; Code:

(defcustom my-notes-directory "~/notes/"
  "Directory containing my notes."
  :type '(string)
  :group 'my-emacs)

(use-package org
  :ensure nil ; built-in
  :custom (org-directory my-notes-directory)
  :custom (org-agenda-files
           (list org-directory))
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
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired))
  :config
  (setq denote-directory my-notes-directory)
  ;; so TODOs appear in the agenda list
  (push denote-directory org-agenda-files)
  ;; Renames buffer to "[D] <title>", instead of the scary name
  (denote-rename-buffer-mode 1))

(use-package consult-denote
  :bind
  (("C-c n f" . consult-denote-find)
   ("C-c n g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

(use-package denote-journal
  :defer nil
  :bind
  (("C-c j j" . denote-journal-new-or-existing-entry)
   ("C-c j n" . denote-journal-new-entry)
   ("C-c j l" . denote-journal-link-or-create-entry))
  :hook (calendar-mode . denote-journal-calendar-mode)
  :config
  ;; Use the "journal" subdirectory of `my-notes-directory'.
  (setq denote-journal-directory
        (expand-file-name "journal" my-notes-directory))
  ;; so TODOs appear in the agenda list
  (push denote-journal-directory org-agenda-files)
  ;; Default keyword for new journal entries.
  (setq denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format 'day))

(provide 'my-org)
;;; my-org.el ends here
