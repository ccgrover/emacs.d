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

(setq gc-cons-threshold (* 100 1024 1024)) ;; 100mb
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
  :custom (flycheck-indication-mode 'left-margin)
  :config (global-flycheck-mode))

(use-package yasnippet
  :config (yas-global-mode))

(use-package lsp-mode
  :custom
  (lsp-completion-provider :none) ;; we use Corfu!

  :init
  (defun my/orderless-dispatch-flex-first (_pattern index _total)
    (and (eq index 0) 'orderless-flex))
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless))
    ;; Optionally configure the first word as flex filtered.
    (setq-local orderless-style-dispatchers (list #'my/orderless-dispatch-flex-first))
    ;; Use debounced completion to reduce LSP server load
    (setq-local completion-at-point-functions (list (cape-capf-buster #'lsp-completion-at-point)))
    ;; Increase company-like debounce for LSP completion
    (setq-local lsp-completion-no-cache nil)) ; enable caching

  :hook
  (lsp-completion-mode . my/lsp-mode-setup-completion)
  :init (setq lsp-keymap-prefix "C-c l")
  :bind (:map lsp-mode-map
              (("C-M-g" . lsp-find-implementation)
               ("C-<return>" . lsp-execute-code-action)))
  :custom (
           ;; Increase idle delay to reduce LSP server load
           (lsp-idle-delay 1.0)
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
           (lsp-completion-show-detail nil)      ;; reduce completion detail
           (lsp-completion-show-kind nil))
  :hook (lsp-mode . lsp-enable-which-key-integration))

(use-package which-key
  :ensure nil ; build-in for Emacs 30+
  :config (which-key-mode))

(use-package hydra)

(use-package lsp-ui
  :custom
  ;; Reduce sideline update frequency to improve performance
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-delay 2.0)
  (lsp-ui-sideline-update-mode 'point)      ;; only update when cursor moves
  (lsp-ui-sideline-show-hover nil)          ;; disable hover info
  (lsp-ui-sideline-show-code-actions nil)   ;; disable code actions
  (lsp-modeline-code-actions-enable nil)
  (lsp-ui-doc-enable nil)                   ;; disable hover doc popup
  (lsp-ui-doc-delay 2.0))

(use-package lsp-java
  ;; use melpa over melpa-stable for newer features
  :pin melpa
  :hook ((java-mode . lsp)
         (java-ts-mode . lsp)
         ;; lsp-lens-mode disabled for performance
         (lsp-mode . editorconfig-mode)
         ;; lsp-java-boot-lens-mode disabled for performance
         )
  ;; use setq instead of :custom so we can just append to vector variables
  :config
  (setq lsp-java-maven-download-sources nil
        ;; set to "verbose" for troubleshooting, otherwise "off"
        lsp-java-trace-server "off"
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
                                                 :path "~/.sdkman/candidates/java/17.0.17-tem/"
                                                 :default t)
                                          (:name "JavaSE-21"
                                                 :path "~/.sdkman/candidates/java/21.0.9-tem")]
        ;; VM args for performance and lombok
        ;; https://github.com/eclipse-jdtls/eclipse.jdt.ls/issues/1469
        lsp-java-vmargs
        (list "-XX:+UseParallelGC"
              "-XX:GCTimeRatio=4"
              "-XX:AdaptiveSizePolicyWeight=90"
              "-Dsun.zip.disableMemoryMapping=true"
              "-Xmx8G"
              "-Xms100m"
              "-XX:+UseStringDeduplication"
              (concat "-javaagent:" my-lombok-path))
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

(use-package lsp-treemacs)

;; lsp-sonarlint disabled for performance - use flycheck/checkstyle instead
;; (use-package lsp-sonarlint
;;   :custom
;;   (lsp-sonarlint-enabled-analyzers '("java"))
;;   (lsp-sonarlint-auto-download t))

(provide 'my-lsp)
;;; my-lsp.el ends here
