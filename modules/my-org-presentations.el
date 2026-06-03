;;; my-org-presentations.el --- For presenting org files -*- lexical-binding: t; -*-

;;; Commentary:

;;  Packages + config for presenting org-mode files.
;;  Source for the majority of this file:
;;  https://systemcrafters.net/emacs-tips/presentations-with-org-present/

;;; Code:

(require 'my-appearance)  ; For my-variable-width-font

(use-package org-present
  :config
  (defun my/org-present-start ()
    ;; ensure images are shown
    (org-display-inline-images)
    (setq header-line-format " ")
    ;; narrower column width due give some centering
    (setq-local visual-fill-column-width 90
                org-hide-emphasis-markers t)
    ;; prevent myself from accidentally editing the slides
    (org-present-read-only))

  (defun my/org-present-end ()
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
