;;; cullen-java-config.el --- Config for Java development  -*- lexical-binding: t; -*-

;;; Commentary:

;;  Config for Java development

;;; Code:

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((java-mode java-ts-mode) .
                 ("jdtls" "--jvm-arg=-javaagent:/home/cullen/.emacs.d/lombok.jar"
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

(provide 'cullen-java-config)
;;; cullen-java-config.el ends here
