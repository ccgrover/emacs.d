;;; my-dbt.el --- DBT support -*- lexical-binding: t; -*-

;;; Commentary:

;;  Trying to get some DBT support in Emacs.  This should include SQL and jinja2

;;; Code:

;;  Copied from https://github.com/CyberShadow/dbt-mode/blob/master/dbt-mode.el
;;  Has a hard time getting that repo to work with "use-package" + ":vc"

(use-package jinja2-mode)

(use-package polymode
  :after jinja2-mode
  :defer nil
  :config
  (define-hostmode dbt/sql-hostmode
                   :mode 'sql-mode)
  (define-innermode dbt/sql-jinja2-innermode
                    :mode 'jinja2-mode
                    :head-matcher "{[%{][+-]?"
                    :tail-matcher "[+-]?[%}]}"
                    :head-mode 'body
                    :tail-mode 'body)
  ;; Comment blocks don't seem to work very well with jinja2/polymode,
  ;; work around this by defining an inner mode just for the comments.
  (define-innermode dbt/sql-jinja2-comments-innermode
                    :head-matcher "{#[+-]?"
                    :tail-matcher "[+-]?#}"
                    :head-mode 'body
                    :tail-mode 'body
                    :adjust-face 'font-lock-comment-face
                    :head-adjust-face 'font-lock-comment-face
                    :tail-adjust-face 'font-lock-comment-face
                    )
  (define-polymode dbt-mode
                   :hostmode 'dbt/sql-hostmode
                   :innermodes '(dbt/sql-jinja2-comments-innermode
                                 dbt/sql-jinja2-innermode))
  (add-to-list 'auto-mode-alist
               '("/\\(dbt\\|queries\\|macros\\|dbt_modules\\)/.*\\.sql\\'" . dbt-mode)))
(provide 'my-dbt)
;;; my-dbt.el ends here
