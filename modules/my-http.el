;;; my-http.el --- HTTP client (verb) -*- lexical-binding: t; -*-

;;; Commentary:

;;  verb: org-mode HTTP client.  C-c C-r opens the verb command map.
;;
;;  TLS client certificates are looked up automatically from ~/.authinfo:
;;
;;    machine ibm-entitlement-gateway.stage.api.redhat.com \
;;            cert /path/to/cert.pem key /path/to/key.pem
;;
;;  The advice below passes :client-certificate t to open-network-stream
;;  for hosts that have a cert entry, letting Emacs handle the lookup.

;;; Code:

(require 'auth-source)

(defun my/open-network-stream-with-client-cert (orig name buffer host service &rest args)
  "Pass :client-certificate t for hosts with a cert entry in ~/.authinfo."
  (if (auth-source-search :host host :max 1 :require '(:cert))
      (apply orig name buffer host service :client-certificate t args)
    (apply orig name buffer host service args)))

(advice-add 'open-network-stream :around
            #'my/open-network-stream-with-client-cert)

(use-package verb
  :after org
  :config
  (setq verb-auto-kill-response-buffers t)
  (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

(provide 'my-http)
;;; my-http.el ends here
