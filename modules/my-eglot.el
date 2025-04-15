;;; my-eglot.el --- eglot packages -*- lexical-binding: t; -*-

;;; Commentary:

;;  eglot and eglot-java packages

;;; Code:

;; generic performance-related config

(setq gc-cons-threshold (* 100 1024 1024)) ;; 100mb
(setq read-process-output-max (* 10 1024 1024)) ;; 10mb
(setq process-adaptive-read-buffering nil)

;; eglot / Java packages

(defvar my-java-debug-plugin "/home/cgrover/.m2/repository/com/microsoft/java/com.microsoft.java.debug.plugin/0.53.1/com.microsoft.java.debug.plugin-0.53.1.jar"
  "The plugin that will be used by `dape` for Java debugging support.")

(use-package eglot
  :config
  (setq completion-category-overrides '((eglot (styles orderless))
                                      (eglot-capf (styles orderless))))
  (setq eglot-report-progress nil)
  (add-to-list 'eglot-server-programs
               '((java-mode java-ts-mode) .
                 ("jdtls" "--jvm-arg=-javaagent:/home/cgrover/.emacs.d/tools/lombok.jar"
                  :initializationOptions
                  (:bundles ["/home/cgrover/.m2/repository/com/microsoft/java/com.microsoft.java.debug.plugin/0.53.1/com.microsoft.java.debug.plugin-0.53.1.jar"]
                   :settings
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
                       ])))))))
  :bind
  (("M-RET" . eglot-code-actions))
  ;; https://github.com/minad/corfu/wiki#configuring-corfu-for-eglot
  :config
  (setq completion-category-defaults nil)
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

(defun my-default-code-style-hook()
  "Code style for `java-mode`."
  (setq c-basic-offset 4
        c-label-offset 0
        indent-tabs-mode nil
        require-final-newline t))
(add-hook 'java-mode-hook 'my-default-code-style-hook)

(defun my-java-mode-hook ()
  "Set up modes want in 'java-mode'."
  (eglot-ensure)
  (auto-fill-mode)
  (flymake-mode)
  (subword-mode)
  (yas-minor-mode)
  (when window-system
    (set-fringe-style '(8 . 0))))
(add-hook 'java-mode-hook 'my-java-mode-hook)

(advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)

(use-package dape
  :config
  (setq dape-cwd-function 'projectile-project-root))

(use-package projectile
  :custom (projectile-create-missing-test-files t))

(use-package yasnippet
  :config (yas-global-mode))

;; _
(provide 'my-eglot)
;;; my-eglot.el ends here
