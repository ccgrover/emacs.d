;;; my-snowflake.el --- Snowflake support -*- lexical-binding: t; -*-

;;; Commentary:

;;  Trying to get some Snowflake support in Emacs.

;;; Code:

(require 'seq)

(defcustom my-sql-snowflake-options
  ;; no custom options for now
  '()
  "List of command line options for Snowflake CLI."
  :type '(repeat string)
  :group 'my-emacs)

(defcustom my-sql-snowflake-login-params '(user)
  "Login parameters to needed to connect to Snowflake."
  :type 'sql-login-params
  :group 'my-emacs)

(defun my-snowflake-sql-comint (product options &optional buf-name)
  "Connect to Snowflake CLI (PRODUCT) in a comint buffer with OPTIONS in BUF-NAME."
  (let ((params
         (append
          ;; "snow sql" is used to execute queries
          (list "sql")
          ;; using "sql-user" as the connection name for now
          (if (not (string= "" sql-user))
              (list "--connection" sql-user))
          ;; and any other options provided
          options)))
    (sql-comint product params buf-name)))

(use-package sql
  :defer nil
  :ensure nil ; built-in
  :config
  
  (sql-add-product
   'my-snowflake "Snowflake"
   :sqli-program "snow"
   :sqli-login 'my-sql-snowflake-login-params
   :sqli-comint-func #'my-snowflake-sql-comint
   :prompt-regexp "^ > "
   :prompt-cont-regexp "^   "
   )
  
  (add-to-list 'sql-connection-alist
               '("Snowflake - RH Prod"
                 (sql-product 'my-snowflake)
                 (sql-user "rh_prod")))
  (add-to-list 'sql-connection-alist
               '("Test Maria"
                 (sql-product 'mariadb)
                 (sql-user "root")
                 (sql-password "my-secure-password")
                 (sql-server "localhost")
                 (sql-port 3306)
                 ))
  
  (defun sql-snowflake--strip-junk (output-string)
    "Remove whitespace noise from OUTPUT-STRING, which should be snowsql's output.
It seems snowsql injects this whitespace in order to make room in the terminal
for its completions popup. Completion functionality can be disabled, but this
whitespace is still included in the output."
    (thread-last output-string
                 (replace-regexp-in-string (rx (= 7 "\r\n")) "")
                 (replace-regexp-in-string (rx (= 80 space) "\r\r") "")))

  (add-hook 'sql-interactive-mode-hook
            (lambda ()
              (when (eq sql-product 'snowflake)
                (add-hook 'comint-preoutput-filter-functions
                          #'sql-snowflake--strip-junk
                          ;; make it buffer-local
                          nil t)))))



(provide 'my-snowflake)
;;; my-snowflake.el ends here
