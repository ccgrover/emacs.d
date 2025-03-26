;;; my-lsp.el --- LSP packages -*- lexical-binding: t; -*-

;;; Commentary:

;;  LSP & lsp-mode packages

;;; Code:

;; generic performance-related config

(setq gc-cons-threshold (* 100 1024 1024)) ;; 100mb
(setq read-process-output-max (* 10 1024 1024)) ;; 10mb
(setq process-adaptive-read-buffering nil)

;; LSP packages

(use-package projectile)

(use-package flycheck
  :hook (flycheck-mode . flycheck-set-indication-mode)
  :custom (flycheck-indication-mode 'left-margin))

(use-package yasnippet
  :config (yas-global-mode))

(use-package lsp-mode
  :bind-keymap ("C-c l" . lsp-command-map)
  :custom (lsp-completion-provider :none) ;; we use Corfu!
  :custom (lsp-idle-delay nil)
  :init
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless))
    ;; Optionally configure the cape-capf-buster.
    (setq-local completion-at-point-functions (list (cape-capf-buster #'lsp-completion-at-point))))
  :hook (lsp-completion-mode . my/lsp-mode-setup-completion)
  :hook (lsp-mode . lsp-enable-which-key-integration))

(use-package hydra)

(use-package lsp-ui)

(use-package which-key
  :config (which-key-mode))

(use-package lsp-java
  :hook (java-mode . lsp)
  :config
  (let ((lombok-jvm-arg (concat "-javaagent:" (expand-file-name "./tools/lombok.jar" user-emacs-directory))))
    (setq lsp-java-vmargs
        (list
         ;; performance recommendations from https://github.com/eclipse-jdtls/eclipse.jdt.ls/issues/1469
         "-XX:+UseParallelGC"
         "-XX:GCTimeRatio=4"
         "-XX:AdaptiveSizePolicyWeight=90"
         "-Dsun.zip.disableMemoryMapping=true"
         "-Xmx8G"
         "-Xms100m"
         "-XX:+UseStringDeduplication"
         lombok-jvm-arg)))
  :custom (lsp-java-format-insert-spaces t)
  :custom (lsp-java-completion-favorite-static-members
      ["java.util.stream.Collectors.*"
       "org.awaitility.Awaitility.await"
       ;; ArchUnit entrypoints
       "com.tngtech.archunit.lang.syntax.ArchRuleDefinition.*"
       "com.tngtech.archunit.library.Architectures.*"
       ;; Spring test utilities
       "org.springframework.test.web.client.match.MockRestRequestMatchers.*"
       "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*"
       "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*"
       "org.springframework.test.web.servlet.result.MockMvcResultHandlers.*"
       ;; HATEOAS
       "org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.*"
       ;; other common testing libraries
       "org.assertj.core.api.Assertions.*"
       "org.assertj.core.api.Assumptions.*"
       "org.junit.jupiter.api.Assertions.*"
       "org.junit.jupiter.api.Assumptions.*"
       "org.junit.jupiter.params.provider.Arguments.*"
       "org.mockito.Mockito.*"
       "org.mockito.ArgumentMatchers.*"
       "org.mockito.Answers.*"
       "org.junit.Assert.*"
       "org.junit.Assume.*"]))

(use-package lsp-java-boot
  :hook (lsp-mode . lsp-lens-mode)
        (java-mode . lsp-java-boot-lens-mode))

(use-package dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode))

(use-package dap-java
  :ensure nil)

(use-package consult-lsp)

(use-package lsp-treemacs)

(use-package lsp-sonarlint
  :custom (lsp-sonarlint-auto-download t))

;; _
(provide 'my-lsp)
;;; my-lsp.el ends here
