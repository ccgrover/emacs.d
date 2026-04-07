;;; my-lsp.el --- LSP packages -*- lexical-binding: t; -*-

;;; Commentary:

;;  LSP & lsp-mode packages

;;; Code:

;; variables used within this config
(defcustom my-lombok-path nil
  "Path to lombok.jar for JDTLS to use."
  :type '(string)
  :group 'my-emacs)

;; generic performance-related config

;; GC is now managed by gcmh package in init.el
(setq read-process-output-max (* 10 1024 1024)) ;; 10mb
(setq process-adaptive-read-buffering nil)

;; Containerfile code until I find somewhere better to put it

(use-package dockerfile-mode
  :custom (dockerfile-mode-command "podman"))

;; LSP packages

;; prefer java-ts-mode to java-mode
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))


(use-package ag)

(use-package projectile
  :init
  :custom ((projectile-create-missing-test-files t)
           (projectile-project-search-path '("~/Workspace/"))
           (projectile-auto-cleanup-known-projects t)
           (projectile-sort-order 'recently-active)
           ;; replace project.el, which appears by default at C-x p
           (projectile-keymap-prefix (kbd "C-x p")))
  :config
  (projectile-mode +1))

(use-package flycheck
  :defer nil
  ;; manually refresh buffer due to no lsp-idle-delay
  :bind (("<f5>" . flycheck-buffer)
         ("M-n"  . flycheck-next-error)
         ("M-p"  . flycheck-previous-error))
  :hook (flycheck-mode . flycheck-set-indication-mode)
  :custom
  (flycheck-indication-mode 'left-margin)
  ;; Increase debounce to reduce overhead - profiler showed frequent checks
  (flycheck-check-syntax-automatically '(save mode-enabled))  ;; only check on save
  (flycheck-idle-change-delay 2.0)       ;; increase delay if adding 'idle-change back
  (flycheck-idle-buffer-switch-delay 2.0)
  :config (global-flycheck-mode))

(use-package yasnippet
  :config (yas-global-mode))

(use-package lsp-mode
  :custom
  (lsp-completion-provider :none) ;; we use Corfu!

  :init
  (defun my/orderless-dispatch-flex-first (_pattern index _total)
    (and (eq index 0) 'orderless-flex))

  ;; CRITICAL: Prevent LSP from running in minibuffer
  (defun my/lsp-mode-setup-completion ()
    ;; Only set up LSP completion if NOT in minibuffer
    (unless (minibufferp)
      (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
            '(orderless))
      ;; Optionally configure the first word as flex filtered.
      (setq-local orderless-style-dispatchers (list #'my/orderless-dispatch-flex-first))
      ;; Use debounced completion to reduce LSP server load
      (setq-local completion-at-point-functions
                  (cons (cape-capf-buster #'lsp-completion-at-point)
                        (remove #'lsp-completion-at-point completion-at-point-functions)))
      ;; Increase company-like debounce for LSP completion
      (setq-local lsp-completion-no-cache nil)))

  :hook
  (lsp-completion-mode . my/lsp-mode-setup-completion)
  :init
  (setq lsp-keymap-prefix "C-c l")

  ;; CRITICAL: Never activate LSP in minibuffer - prevents freeze during M-x
  (defun my/lsp-prevent-minibuffer ()
    "Prevent LSP mode from activating in minibuffer."
    (when (minibufferp)
      (setq-local lsp-mode nil)
      (setq-local completion-at-point-functions
                  (remove #'lsp-completion-at-point completion-at-point-functions))))

  (add-hook 'minibuffer-setup-hook #'my/lsp-prevent-minibuffer)
  :bind (:map lsp-mode-map
              (("C-M-g" . lsp-find-implementation)
               ("C-<return>" . lsp-execute-code-action)))
  :custom (
           ;; Increase idle delay to reduce LSP server load
           (lsp-idle-delay 1.0)
           ;; Critical: Reduce timeout to prevent long blocking
           (lsp-response-timeout 5)      ; reduce from 10s to 5s timeout
           (lsp-disabled-clients '(semgrep-ls))
           (lsp-enable-file-watchers nil)
           (lsp-headerline-breadcrumb-enable nil)
           (lsp-completion-enable t)
           ;; additional performance optimizations
           (lsp-enable-on-type-formatting nil)
           ;; Disable expensive LSP features
           (lsp-enable-symbol-highlighting nil)  ;; disable document highlight
           (lsp-lens-enable nil)                 ;; disable code lenses
           (lsp-signature-auto-activate nil)     ;; disable signature help on typing
           (lsp-signature-render-documentation nil)
           (lsp-completion-show-detail t)        ;; reduce completion detail
           (lsp-completion-show-kind t)
           ;; Critical performance fixes from profiler analysis
           (lsp-enable-text-document-color-provider nil)  ;; expensive and rarely needed
           (lsp-enable-folding nil)              ;; rarely used, often expensive
           (lsp-enable-indentation nil)          ;; we use treesit-indent
           (lsp-enable-links nil)                ;; links parsing can be expensive
           (lsp-modeline-diagnostics-enable nil) ;; reduce modeline overhead
           ;; Enable I/O logging when debugging - creates *lsp-log* buffer
           ;; WARNING: This is VERY verbose and will impact performance
           ;; For timing info: temporarily set to t, then back to nil
           (lsp-log-io nil)                      ;; disable full I/O logging
           ;; Server-side tracing (less verbose than lsp-log-io)
           (lsp-server-trace nil)                ;; "messages" or "verbose" for debugging
           ;; Reduce diagnostic overhead - major memory issue in profiler
           (lsp-diagnostics-provider :flycheck)  ;; use flycheck for display
           (lsp-diagnostics-modeline-scope :project) ;; reduce diagnostic scope
           ;; Disable synchronous operations before save
           (lsp-before-save-edits nil)           ;; formatting on save causes blocking requests
           (lsp-auto-execute-action nil))
  :hook (lsp-mode . lsp-enable-which-key-integration))

(use-package which-key
  :ensure nil ; build-in for Emacs 30+
  :config (which-key-mode))

(use-package hydra)

(use-package lsp-ui
  :custom
  ;; Disable sideline completely - showed up as expensive in profiler
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-show-code-actions nil)
  (lsp-modeline-code-actions-enable nil)
  ;; Keep doc disabled
  (lsp-ui-doc-enable nil)
  ;; Disable peek features for performance
  (lsp-ui-peek-enable nil))

(use-package lsp-java
  ;; use melpa over melpa-stable for newer features
  :pin melpa
  :hook ((java-mode . lsp)
         (java-ts-mode . lsp)
         ;; lsp-lens-mode disabled for performance
         ;; editorconfig now enabled globally in my-misc.el
         ;; lsp-java-boot-lens-mode disabled for performance
         )
  ;; use setq instead of :custom so we can just append to vector variables
  :config
  (setq lsp-java-maven-download-sources nil
        ;; set to "verbose" for troubleshooting, otherwise "off"
        lsp-java-trace-server "off"
        ;; Workspace caching configuration
        lsp-java-workspace-cache-dir (expand-file-name ".cache/" lsp-java-workspace-dir)
        lsp-java-configuration-workspace-cache-limit 90  ; Keep cache for 90 days
        ;; Reduce auto-build overhead on startup
        lsp-java-autobuild-enabled nil  ; Disable auto-build to reduce startup indexing
        ;; fewer max completion candidates for performance
        lsp-java-completion-max-results 15  ; reduced from 20
        ;; reduce completion overhead
        lsp-java-completion-guess-method-arguments nil
        ;; disable formatting to possibly save some time and hassle
        lsp-java-format-enabled nil
        lsp-java-format-on-type-enabled nil
        ;; null analysis including JSpecify annotations
        lsp-java-compile-null-analysis-mode "automatic"
        lsp-java-compile-null-analysis-nonnull
        (vconcat '("org.jspecify.annotations.NonNull")
                 lsp-java-compile-null-analysis-nonnull)
        lsp-java-compile-null-analysis-nullable
        (vconcat '("org.jspecify.annotations.Nullable")
                 lsp-java-compile-null-analysis-nullable)
        ;; Maven settings
        ;; lsp-java-configuration-maven-user-settings "~/.m2/settings.xml"
        lsp-java-configuration-runtimes '[(:name "JavaSE-17"
                                                 :path "/home/cgrover/.sdkman/candidates/java/17.0.17-tem/")
                                          (:name "JavaSE-21"
                                                 :path "/home/cgrover/.sdkman/candidates/java/21.0.9-tem/"
                                                 :default t)]
        ;; VM args for performance and lombok
        ;; https://github.com/eclipse-jdtls/eclipse.jdt.ls/issues/1469
        lsp-java-vmargs
        (append
         (list "-XX:+UseParallelGC"
               "-XX:GCTimeRatio=4"
               "-XX:AdaptiveSizePolicyWeight=90"
               "-Dsun.zip.disableMemoryMapping=true"
               "-Xmx8G"
               "-Xms100m"
               "-XX:+UseStringDeduplication")
         ;; Only add lombok if path is configured
         (when my-lombok-path
           (list (concat "-javaagent:" (expand-file-name my-lombok-path)))))
        ;; customize static imports for completion
        lsp-java-completion-favorite-static-members
        (vconcat '(
                   ;; Spring testing utilities
                   "org.springframework.test.web.client.match.MockRestRequestMatchers.*"
                   "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*"
                   "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*"
                   "org.springframework.test.web.servlet.result.MockMvcResultHandlers.*"
                   ;; Spring HATEOAS
                   "org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.*"
                   ;; Other utilities
                   "java.util.stream.Collectors.*"
                   "org.awaitility.Awaitility.await"
                   ;; ArchUnit entrypoints
                   "com.tngtech.archunit.lang.syntax.ArchRuleDefinition.*"
                   "com.tngtech.archunit.library.Architectures.*"
                   ;; other common testing libraries
                   "org.assertj.core.api.Assertions.*"
                   "org.assertj.core.api.Assumptions.*"
                   "org.junit.jupiter.params.provider.Arguments.*"
                   "org.junit.jupiter.api.Named.named"
                   )
                 lsp-java-completion-favorite-static-members)))

(use-package dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode))

(use-package dap-java
  :ensure nil
  :bind
  (("C-c t c" . dap-java-run-test-class)
   ("C-c t m" . dap-java-run-test-method)
   ("C-c t t" . dap-java-run-last-test)))

(use-package consult-lsp
  :defer nil
  :bind ("C-c b" . consult-project-buffer)
  :config
  (define-key lsp-mode-map [remap xref-find-apropos]
              #'consult-lsp-symbols))

;; Treemacs - file tree explorer with projectile integration
(use-package treemacs
  :custom
  ;; Visual and layout settings
  (treemacs-width 35)
  (treemacs-position 'left)
  (treemacs-is-never-other-window t)
  (treemacs-no-delete-other-windows t)

  ;; Display behavior
  (treemacs-sorting 'alphabetic-asc)
  (treemacs-follow-after-init nil)
  (treemacs-expand-after-init t)
  (treemacs-expand-added-projects t)
  (treemacs-recenter-after-file-follow nil)

  ;; Project follow settings
  (treemacs-project-follow-cleanup nil)
  (treemacs-project-follow-into-home nil)

  ;; File follow settings
  (treemacs-file-follow-delay 0.2)

  ;; Workspace persistence
  (treemacs-persist-file (expand-file-name ".treemacs-persist" user-emacs-directory))

  :bind
  (("M-0" . treemacs)
   ("C-c t 0" . treemacs-select-window))

  :config
  ;; Enable follow modes for automatic synchronization
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-project-follow-mode t))

;; Projectile integration for treemacs
(use-package treemacs-projectile
  :after (treemacs projectile)
  :bind
  (("C-c p t" . treemacs-projectile)))

;; LSP integration for treemacs
(use-package lsp-treemacs
  :after (lsp-mode treemacs))

;; lsp-sonarlint disabled for performance - use flycheck/checkstyle instead
;; (use-package lsp-sonarlint
;;   :custom
;;   (lsp-sonarlint-enabled-analyzers '("java"))
;;   (lsp-sonarlint-auto-download t))

;; Ensure clean JDTLS shutdown to preserve workspace state
(defun my/lsp-java-clean-shutdown ()
  "Notify LSP workspaces before shutdown to allow clean state save."
  (when (and (featurep 'lsp-mode) (lsp-workspaces))
    (message "Shutting down LSP workspaces...")
    (lsp-foreach-workspace
     (lambda (workspace)
       (with-lsp-workspace workspace
         ;; Send shutdown request
         (lsp-request "shutdown" nil)
         (lsp-notify "exit" nil))))
    (sit-for 0.3)))  ; Brief pause to allow shutdown to complete

(add-hook 'kill-emacs-hook #'my/lsp-java-clean-shutdown 90)

(provide 'my-lsp)
;;; my-lsp.el ends here
