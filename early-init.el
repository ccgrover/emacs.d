;;; early-init.el --- (Early) init! -*- lexical-binding: t -*-
;;; Commentary:

;;  Early init stuff. Mostly taken from the CraftedEmacs early-init module

;;; Code:

;;  envvar for LSP performance
(setenv "LSP_USE_PLISTS" "true")

;; package setup

(require 'package)
(require 'use-package-ensure)

(add-to-list 'package-archives '("stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(customize-set-variable 'package-archive-priorities
                        '(("gnu"    . 99)   ; prefer GNU packages
                          ("nongnu" . 80)   ; use non-gnu packages if
                                            ; not found in GNU elpa
                          ("stable" . 70)   ; prefer "released" versions
                                            ; from melpa
                          ("melpa"  . 0)))  ; if all else fails, get it
				            ; from melpa

(setq use-package-always-ensure t)

;;; Forms to refresh package archive contents
;; These functions are available to use for deciding if
;; `package-refresh-contents' needs to be run during startup.  As this
;; can slow things down, it is only run if the archives are considered
;; stale.  Archives are considered stale (by default) when they are 1
;; day old.  Set the `crafted-package-update-days' to a larger value
;; in your `early-init' file to changes this behavior
(require 'time-date)

(defvar crafted-package-perform-stale-archive-check t
  "Check if any package archives are stale.

Set this value in your `early-init.el' file.")

(defvar crafted-package-update-days 1
  "Number of days before an archive will be considered stale.

Set this value in your `early-init.el' file")

(defun crafted-package-archive-stale-p (archive)
  "Return t if ARCHIVE is stale.

ARCHIVE is stale if the on-disk cache is older than
`crafted-package-update-days' old.  If
`crafted-package-perform-stale-archive-check' is nil, the check
is skipped"
  (let* ((today (decode-time nil nil t))
         (archive-name (expand-file-name
                        (format "archives/%s/archive-contents" archive)
                        package-user-dir))
         (last-update-time (decode-time (file-attribute-modification-time
                                         (file-attributes archive-name))))
         (delta (make-decoded-time :day crafted-package-update-days)))
    (when crafted-package-perform-stale-archive-check
      (time-less-p (encode-time (decoded-time-add last-update-time delta))
                   (encode-time today)))))

(defun crafted-package-archives-stale-p ()
  "Return t if any package archives' cache is out of date.

Check each archive listed in `package-archives', if the on-disk
cache is older than `crafted-package-update-days', return a
non-nil value.  Fails fast, will return t for the first stale
archive found or nil if they are all up-to-date"
  (interactive)
  (cl-some #'crafted-package-archive-stale-p (mapcar #'car package-archives)))

(defun crafted-package-initialize ()
  "Initialize the package system.

Run this in the `before-init-hook'"

  (when package-enable-at-startup
    (package-initialize)

    (require 'seq)
    (message "crafted-package-config: checking package archives")
    (cond ((seq-empty-p package-archive-contents)
           (progn
             (message "crafted-package-config: package archives empty, initalizing")
             (package-refresh-contents)))
          ((crafted-package-archives-stale-p)
           (progn
             (message "crafted-package-config: package archives stale, refreshing")
             (package-refresh-contents t))))
    (message "crafted-package-config: package system initialized!")))

;;; Initialize package system
;; Refresh archives if necessary before init file runs.
(add-hook 'before-init-hook #'crafted-package-initialize)

;;; _
(provide 'early-init)
;;; early-init.el ends here
