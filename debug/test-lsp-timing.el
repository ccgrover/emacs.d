;;; test-lsp-timing.el --- Test LSP timing advice -*- lexical-binding: t; -*-

;;; Commentary:
;; This file tests the LSP timing advice by triggering slow LSP operations

;;; Code:

(defun test-lsp-timing ()
  "Test LSP timing advice by triggering LSP requests."
  (interactive)

  (message "")
  (message "========================================")
  (message "LSP Timing Test Starting...")
  (message "========================================")

  ;; Check if in a buffer with LSP active
  (unless (and (featurep 'lsp-mode) (lsp-workspaces))
    (user-error "LSP is not active in this buffer! Open a Java file first"))

  ;; Check if advice is loaded
  (unless (advice-member-p #'lsp--timing-after-request 'lsp-request)
    (message "⚠️  WARNING: Timing advice is NOT active!")
    (message "Run: (load-file (expand-file-name \"lsp-timing-advice.el\" user-emacs-directory))")
    (user-error "Timing advice not loaded"))

  (message "✓ LSP is active")
  (message "✓ Timing advice is loaded")
  (message "")
  (message "Triggering LSP requests...")
  (message "Watch for '[LSP Timing]' messages below:")
  (message "")

  ;; Test 1: Document symbols (usually slow)
  (message "Test 1: Requesting document symbols...")
  (condition-case err
      (progn
        (lsp-request "textDocument/documentSymbol"
                     (lsp--text-document-identifier))
        (message "  ✓ Document symbols request completed"))
    (error
     (message "  ✗ Error: %s" (error-message-string err))))

  ;; Small delay between tests
  (sleep-for 0.5)

  ;; Test 2: Workspace symbols (can be slow)
  (message "Test 2: Requesting workspace symbols...")
  (condition-case err
      (progn
        (lsp-request "workspace/symbol"
                     (list :query "Service"))
        (message "  ✓ Workspace symbols request completed"))
    (error
     (message "  ✗ Error: %s" (error-message-string err))))

  ;; Small delay
  (sleep-for 0.5)

  ;; Test 3: Code actions (can be slow)
  (message "Test 3: Requesting code actions at point...")
  (condition-case err
      (progn
        (lsp-request "textDocument/codeAction"
                     (lsp--text-document-code-action-params))
        (message "  ✓ Code actions request completed"))
    (error
     (message "  ✗ Error: %s" (error-message-string err))))

  (message "")
  (message "========================================")
  (message "Test Complete!")
  (message "========================================")
  (message "")
  (message "Look above for '[LSP Timing]' messages.")
  (message "If you see them, the timing advice is working!")
  (message "If not, check that requests took > 100ms to appear."))

;; Interactive command for easy testing
(defun test-lsp-timing-simple ()
  "Simple LSP timing test - just request completion at point."
  (interactive)

  (unless (and (featurep 'lsp-mode) (lsp-workspaces))
    (user-error "LSP is not active! Open a Java file first"))

  (message "")
  (message "=== Simple LSP Timing Test ===")
  (message "Requesting completion at current point...")
  (message "")

  (condition-case err
      (let ((completions (lsp-request "textDocument/completion"
                                       (lsp--make-completion-params))))
        (message "✓ Received %d completions"
                 (length (or (plist-get completions :items)
                            completions)))
        (message "")
        (message "Check above for '[LSP Timing]' message!")
        (message "Expected: '[LSP Timing] textDocument/completion took XXXms'"))
    (error
     (message "✗ Error: %s" (error-message-string err)))))

(provide 'test-lsp-timing)
;;; test-lsp-timing.el ends here
