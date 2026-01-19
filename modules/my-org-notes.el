;;; my-org-notes.el --- org-mode config -*- lexical-binding: t; -*-

;;; Commentary:

;;  Packages for note-taking, ft org-mode.

;;; Code:

(defcustom my-notes-directory "~/Notes/"
  "Directory containing my notes."
  :type '(string)
  :group 'my-emacs)

(defcustom my-org-column-width 110
  "Column width (in chars) for `org-mode' buffers."
  :type '(integer)
  :group 'my-emacs)

(use-package org
  :ensure nil ; built-in
  :custom (org-directory my-notes-directory)
  :custom (org-agenda-files
           (list org-directory))
  :custom (denote-date-prompt-use-org-read-date t)
  :config (org-babel-do-load-languages
           'org-babel-load-languages
           '((shell . t)
             (plantuml . t)))
  :config
  (define-prefix-command 'my-org-mode-map)
  (keymap-set 'my-org-mode-map "a" #'org-agenda)
  (keymap-set 'my-org-mode-map "l" #'org-todo-list)
  (keymap-set 'my-org-mode-map "c" #'org-capture)
  (keymap-global-set "C-c o" 'my-org-mode-map)
  ;; appearance options - use 'visible-mode' to toggle visible
  (setq org-hide-emphasis-markers t)
  ;; Resize Org headings
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :weight 'medium :height (cdr face)))
  ;; Make the document title a bit bigger
  (set-face-attribute 'org-document-title nil :weight 'bold :height 1.3))

;; using visual-fill-column to center org files
(use-package visual-fill-column
  :custom ((visual-fill-column-width my-org-column-width)
           (visual-fill-column-center-text t))
  :config
  (defun my/center-org-buffers ()
    ;; Center org buffers and let lines wrap.
    (visual-fill-column-mode 1)
    (visual-line-mode 1))
  (add-hook 'org-mode-hook 'my/center-org-buffers))

(defun my/set-denote-dir (orig-fun &rest args)
  "Call ORIG-FUN with ARGS using the `pages' subdir for denote."
  (let ((denote-use-directory (expand-file-name "pages" denote-directory)))
    (apply orig-fun args)))

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
  (setq denote-directory (expand-file-name my-notes-directory))
  (setq denote-known-keywords
        '("emacs"
          "giftideas"
          "kids"
          "pathfinder"
          "homeserver"))
  ;; so TODOs appear in the agenda list
  (push denote-directory org-agenda-files)
  ;; Renames buffer to "[D] <title>", instead of the scary name
  (denote-rename-buffer-mode 1)
  (advice-add 'denote :around #'my/set-denote-dir))

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
  ;; Default keyword for new journal entries.
  (setq denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format 'day))

(use-package org-present)

(provide 'my-org-notes)
;;; my-org-notes.el ends here
