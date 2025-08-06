;;; my-appearance.el --- Emacs appearance -*- lexical-binding: t; -*-

;;; Commentary:

;;  Appearance config, e.g. fonts, colors

;;; Code:

;; Font!

;; A nice monospace font with Italics variants - nice!
(add-to-list 'default-frame-alist
             '(font . "Source Code Pro-12"))
(set-face-attribute 'default nil :font "Source Code Pro-12")
(set-face-attribute 'fixed-pitch nil :font "Source Code Pro-12")

;; a little breathing room on the left/right fringes
(set-fringe-mode 20)

;; display line numbers for all programming modes

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'yaml-mode-hook 'display-line-numbers-mode)
(add-hook 'yaml-ts-mode-hook 'display-line-numbers-mode)

;; nicer welcome screen
;; https://github.com/emacs-dashboard/emacs-dashboard

(use-package page-break-lines)
(use-package all-the-icons)
(use-package dashboard
  :config
  (setq dashboard-icon-type 'all-the-icons)
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-items
        '((recents . 5)
          (projects . 5)
          (bookmarks . 5)
          (agenda . 5)))
  (dashboard-setup-startup-hook))

;; themes

(use-package ef-themes
  :ensure t
  :defer nil ;; necessary since ":bind" implies "defer t"
  :bind ("<f7>" . ef-themes-rotate)
  :bind ("<f8>" . ef-themes-toggle)
  :config
  (ef-themes-select 'ef-autumn))

;; https://skybert.net/emacs/simple-modeline-brings-peace-of-mind/

(setq display-time-day-and-date nil)
(setq display-time-load-average nil)
(setq display-time-24hr-format t)
(display-time-mode 1)
(setq-default mode-line-format '(" %b %* %z " display-time-string " (%l, %c)"))

(provide 'my-appearance)
;;; my-appearance.el ends here
