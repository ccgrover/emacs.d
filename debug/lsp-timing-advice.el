;;; lsp-timing-advice.el --- Add timing to LSP requests -*- lexical-binding: t; -*-

;; Add advice to log LSP request timing without full lsp-log-io

(defvar lsp--request-timing-table (make-hash-table :test 'equal)
  "Hash table to track request start times with method name.")

(defvar lsp--current-request-method nil
  "Current request method being timed.")

(defvar lsp--diagnostics-start-time nil
  "Start time for diagnostics updates.")

(defvar lsp--diagnostics-files (make-hash-table :test 'equal)
  "Track files being validated in current diagnostics batch.")

(defun lsp--timing-around-request (orig-fun method &rest args)
  "Time the execution of lsp-request for METHOD."
  (let ((start-time (current-time))
        (lsp--current-request-method method))
    (unwind-protect
        (let ((result (apply orig-fun method args)))
          ;; Log timing after successful completion
          (let* ((elapsed (float-time (time-since start-time)))
                 (elapsed-ms (round (* elapsed 1000)))
                 (timestamp (format-time-string "%H:%M:%S")))
            (when (> elapsed-ms 100)  ; Only log if > 100ms
              (message "[%s] [LSP Timing] %s took %dms" timestamp method elapsed-ms)))
          result)
      ;; Cleanup happens even on error
      (setq lsp--current-request-method nil))))

;; Track diagnostics/validation operations
(defun lsp--timing-diagnostics-start (workspace params)
  "Track when diagnostics update starts."
  (unless lsp--diagnostics-start-time
    (setq lsp--diagnostics-start-time (current-time))
    (clrhash lsp--diagnostics-files))

  ;; Track the file being validated
  (when-let* ((uri (plist-get params :uri))
              (file-name (file-name-nondirectory (lsp--uri-to-path uri))))
    (puthash file-name t lsp--diagnostics-files))

  ;; Use idle timer to detect when batch is complete
  (run-with-idle-timer 0.1 nil #'lsp--timing-diagnostics-maybe-complete))

(defun lsp--timing-diagnostics-maybe-complete ()
  "Check if diagnostics batch is complete and log timing."
  (when lsp--diagnostics-start-time
    (let* ((elapsed (float-time (time-since lsp--diagnostics-start-time)))
           (elapsed-ms (round (* elapsed 1000)))
           (timestamp (format-time-string "%H:%M:%S"))
           (file-count (hash-table-count lsp--diagnostics-files))
           (files (hash-table-keys lsp--diagnostics-files)))

      (when (> elapsed-ms 50)  ; Only log if validation took > 50ms
        (if (> file-count 1)
            (message "[%s] [LSP Server] Validated %d files in %dms"
                     timestamp file-count elapsed-ms)
          (message "[%s] [LSP Server] Validated %s in %dms"
                   timestamp (or (car files) "buffer") elapsed-ms)))

      ;; Reset for next batch
      (setq lsp--diagnostics-start-time nil)
      (clrhash lsp--diagnostics-files))))

;; Remove old advice if present
(advice-remove 'lsp-request #'lsp--timing-before-request)
(advice-remove 'lsp-request #'lsp--timing-after-request)
(advice-remove 'lsp-diagnostics--flycheck-callback #'lsp--timing-diagnostics-start)

;; Apply new around advice to lsp-request
(advice-add 'lsp-request :around #'lsp--timing-around-request)

;; Hook into diagnostics updates to track validation timing
;; This captures the textDocument/publishDiagnostics notifications
(advice-add 'lsp-diagnostics--flycheck-callback :before #'lsp--timing-diagnostics-start)

(message "LSP timing advice loaded - will log requests > 100ms and validation timing to *Messages*")

(provide 'lsp-timing-advice)
;;; lsp-timing-advice.el ends here
