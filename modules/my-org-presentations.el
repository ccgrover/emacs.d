;;; my-org-presentations.el --- For presenting org files -*- lexical-binding: t; -*-

;;; Commentary:

;;  Packages + config for presenting org-mode files.
;;  Source for the majority of this file:
;;  https://systemcrafters.net/emacs-tips/presentations-with-org-present/

;;; Code:

(use-package org-faces
  :ensure nil ; built-in?
  :config
  ;; Resize Org headings
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.0)
                  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :font my-variable-width-font :weight 'medium :height (cdr face)))

  ;; Make the document title a bit bigger
  (set-face-attribute 'org-document-title nil :font my-variable-width-font :weight 'bold :height 1.3)

  ;; Make sure certain org faces use the fixed-pitch face when variable-pitch-mode is on
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org-present
  :config
  (defun my/org-present-start ()
    ;; ensure images are shown
    (org-display-inline-images)
    ;; Tweak font sizes
    (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
                                       (header-line (:height 4.0) variable-pitch)
                                       (org-document-title (:height 1.75) org-document-title)
                                       (org-code (:height 1.55) org-code)
                                       (org-verbatim (:height 1.55) org-verbatim)
                                       (org-block (:height 1.25) org-block)
                                       (org-block-begin-line (:height 0.7) org-block)))
    ;; Set a blank header line string to create blank space at the top
    (setq header-line-format " ")
    ;; narrower column width due give some centering
    (setq-local visual-fill-column-width 90
                org-hide-emphasis-markers t)
    ;; prevent myself from accidentally editing the slides
    (org-present-read-only))

  (defun my/org-present-end ()
    ;; Reset font customizations
    (setq-local face-remapping-alist '((default default)))
    ;; Clear the header line format by setting to `nil'
    (setq header-line-format nil)
    ;; back to defaults
    (kill-local-variable 'visual-fill-column-width)
    (kill-local-variable 'org-hide-emphasis-markers)
    ;; allow editing again
    (org-present-read-write))

  (defun my/org-present-prepare-slide (buffer-name heading)
    ;; Show only top-level headlines
    (org-overview)
    ;; Unfold the current entry
    (org-show-entry)
    ;; Show only direct subheadings of the slide but don't expand them
    (org-show-children))

  ;; Register hooks with org-present
  (add-hook 'org-present-mode-hook 'my/org-present-start)
  (add-hook 'org-present-mode-quit-hook 'my/org-present-end)
  (add-hook 'org-present-after-navigate-functions 'my/org-present-prepare-slide))

(provide 'my-org-presentations)
;;; my-org-presentations.el ends here
