;;; my-appearance.el --- Emacs appearance -*- lexical-binding: t; -*-

;;; Commentary:

;;  Appearance config, e.g. fonts, colors

;;; Code:

;; Font!

;; Set reusable font name variables
(defcustom my-fixed-width-font "Source Code Pro"
  "The font to use for monospaced (fixed width) text."
  :type '(string)
  :group 'my-emacs)

(defcustom my-variable-width-font "Open Sans"
  "The font to use for variable-pitch (document) text."
  :type '(string)
  :group 'my-emacs)

;; A nice monospace font with Italics variants - nice!
(set-frame-font (font-spec :name my-fixed-width-font
                           :size 16) nil t)

;; a little breathing room on the left/right fringes
(set-fringe-mode 20)

;; display line numbers for all programming modes

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'yaml-mode-hook 'display-line-numbers-mode)
(add-hook 'yaml-ts-mode-hook 'display-line-numbers-mode)
(add-hook 'csv-mode-hook 'display-line-numbers-mode)

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
