;;; cullen-lsp-java-config.el --- Config for Java development  -*- lexical-binding: t; -*-

;;; Commentary:

;;  Config for Java development using LSP + lsp-mode

;;; Code:

;; set up LSP

(let ((lombok-jvm-arg (concat "-javaagent:" (expand-file-name "./tools/lombok.jar" user-emacs-directory))))
  (message "JVM arg: %s" lombok-jvm-arg)
  (setq lsp-java-vmargs
        (list
         ;; "-noverify"
         "-Xmx4G"
         ;; "-Xms100m"
         ;; "-XX:+UseG1GC"
         ;; "-XX:+UseStringDeduplication"
         lombok-jvm-arg)))

(setq favorite-static-members
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
       "org.junit.Assume.*"])

(setq lsp-java-completion-favorite-static-members favorite-static-members)

(setq lsp-java-configuration-runtimes
      '[(:name "JavaSE-17"
         :path (substitute-in-file-name "$HOME/.sdkman/candidates/java/17.0.13-tem")
         :default t)])

(add-hook 'java-mode-hook #'lsp)
(dap-auto-configure-mode)

;; define keymaps & keys

;; 't' is for test!
(define-prefix-command 'cullen-java-test-key-map)
(keymap-set 'cullen-java-test-key-map "b" 'lsp-jt-browser)
(keymap-set 'cullen-java-test-key-map "r" 'lsp-jt-report-open)
(keymap-set 'cullen-java-test-key-map "c" 'dap-java-run-test-class)
(keymap-set 'cullen-java-test-key-map "m" 'dap-java-run-test-method)

(define-prefix-command 'cullen-java-key-map)
(keymap-set 'cullen-java-key-map "r" 'lsp-rename)
(keymap-set 'cullen-java-key-map "a" 'lsp-execute-code-action)
(keymap-set 'cullen-java-key-map "d" 'lsp-goto-type-definition)
(keymap-set 'cullen-java-key-map "t" 'cullen-java-test-key-map)

;; 'l' for LSP or language!
(keymap-global-set "C-c l" 'cullen-java-key-map)

(provide 'cullen-lsp-java-config)
;;; cullen-lsp-java-config.el ends here
