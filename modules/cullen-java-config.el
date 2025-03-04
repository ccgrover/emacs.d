;;; cullen-java-config.el --- Config for Java development  -*- lexical-binding: t; -*-

;;; Commentary:

;;  Config for Java development

;;; Code:

;; set up LSP

(setq lombok-path (expand-file-name "./tools/lombok.jar" user-emacs-directory))
(setq lombok-jvm-arg (concat "--jvm-arg=-javaagent:" lombok-path))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((java-mode java-ts-mode) .
                 ("jdtls" "--jvm-arg=-javaagent:/home/cgrover/.emacs.d/lombok.jar"
                  :initializationOptions
                  (:settings
                   (:java
                    (:completion
                     (:favoriteStaticMembers   
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
                       "org.junit.Assume.*"
                       ]))))))))

;; JUnit test runner



;; define keymaps & keys

(define-prefix-command 'cullen-java-key-map)
(keymap-set 'cullen-java-key-map "r" 'eglot-rename)
(keymap-set 'cullen-java-key-map "a" 'eglot-code-actions)
(keymap-set 'cullen-java-key-map "e" 'eglot-code-action-extract)
(keymap-set 'cullen-java-key-map "d" 'eglot-find-typeDefinition)
(keymap-set 'cullen-java-key-map "SPC" 'eglot-code-action-quickfix)

;; 'l' for LSP
(keymap-global-set "C-c l" 'cullen-java-key-map)

(provide 'cullen-java-config)
;;; cullen-java-config.el ends here
