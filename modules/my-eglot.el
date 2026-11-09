;;; my-eglot.el --- Eglot & Java LSP -*- lexical-binding: t; -*-

;;; Commentary:

;;  Eglot-based LSP setup.  Intended to replace my-lsp.el — swap the
;;  (require 'my-lsp) line in init.el for (require 'my-eglot).
;;
;;  Notable differences from lsp-mode:
;;  - Diagnostics go through flymake natively (no flycheck).
;;  - Workspace config lives in `eglot-workspace-configuration` (not lsp-java vars).
;;  - consult-lsp is gone; use xref / consult-imenu instead.
;;  - eglot-java manages JDT-LS separately from lsp-java's install.

;;; Code:

(defcustom my-lombok-path nil
  "Path to lombok.jar for JDTLS to use."
  :type '(string)
  :group 'my-emacs)

;; Process I/O performance
(setq read-process-output-max (* 10 1024 1024))
(setq process-adaptive-read-buffering nil)

(use-package dockerfile-mode
  :custom (dockerfile-mode-command "podman"))

(use-package treesit-auto
  :custom (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package rg
  :config (rg-enable-default-bindings))

(use-package projectile
  :custom ((projectile-create-missing-test-files t)
           (projectile-project-search-path '("~/Workspace/"))
           (projectile-auto-cleanup-known-projects t)
           (projectile-sort-order 'recently-active)
           (projectile-keymap-prefix (kbd "C-x p")))
  :config (projectile-mode +1))

(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :bind (:map flymake-mode-map
              ("<f5>" . flymake-start)
              ("M-n"  . flymake-goto-next-error)
              ("M-p"  . flymake-goto-prev-error)))

(use-package yasnippet
  :config (yas-global-mode))

;; ========== EGLOT ==========

(use-package eglot
  :ensure nil   ; built-in since Emacs 29
  :demand t     ; load immediately so :config runs and registers JDT-LS
  :bind (:map eglot-mode-map
              ("C-M-g"      . xref-find-implementations)
              ("C-<return>" . eglot-code-actions)
              ("C-c l r"    . eglot-rename)
              ("C-c l f"    . eglot-format)
              ("C-c l i"    . eglot-find-implementation)
              ([C-down-mouse-1] . xref-find-definitions-at-mouse)
              ([C-mouse-1]      . ignore))
  :custom
  (eglot-autoshutdown t)
  ;; Disable event logging; re-enable with M-x eglot-events-buffer when debugging
  (eglot-events-buffer-config '(:size 0 :format full))
  ;; Don't block Emacs while connecting
  (eglot-sync-connect nil)
  :config
  ;; Orderless style for eglot in-buffer completions
  (setf (alist-get 'styles (alist-get 'eglot completion-category-defaults))
        '(orderless))

  ;; ========== JDT-LS ==========

  (defvar my/jdtls-jvm-args
    (append
     '("-XX:+UseParallelGC"
       "-XX:GCTimeRatio=4"
       "-XX:AdaptiveSizePolicyWeight=90"
       "-Dsun.zip.disableMemoryMapping=true"
       "-Xmx8G"
       "-Xms100m"
       "-XX:+UseStringDeduplication"
       "--add-modules=ALL-SYSTEM"
       "--add-opens" "java.base/java.util=ALL-UNNAMED"
       "--add-opens" "java.base/java.lang=ALL-UNNAMED")
     (when my-lombok-path
       (list (concat "-javaagent:" (expand-file-name my-lombok-path))))))

  (defclass my/jdtls (eglot-lsp-server) ()
    :documentation "Eclipse JDT Language Server.")

  (cl-defmethod eglot-initialization-options ((server my/jdtls))
    `(:extendedClientCapabilities (:classFileContentsSupport t)
      :workspaceFolders
      [,@(cl-delete-duplicates
          (mapcar #'eglot--path-to-uri
                  (let* ((root (project-root (eglot--project server))))
                    (cons root
                          (mapcar #'file-name-directory
                                  (append
                                   (file-expand-wildcards (concat root "/*/pom.xml"))
                                   (file-expand-wildcards (concat root "/*/build.gradle"))
                                   (file-expand-wildcards (concat root "/*/build.gradle.kts"))
                                   (file-expand-wildcards (concat root "*/.project")))))))
          :test #'string=)]
      ,@(when-let ((home (or (getenv "JAVA_HOME")
                             (ignore-errors
                               (expand-file-name ".."
                                 (file-name-directory
                                  (file-chase-links (executable-find "javac"))))))))
          `(:settings (:java (:home ,home)
                       :import (:gradle (:enabled t :wrapper (:enabled t))))))))

  (cl-defmethod eglot-execute-command
      ((_server my/jdtls) (_cmd (eql java.apply.workspaceEdit)) arguments)
    "Eclipse JDT breaks spec and replies with edits as arguments."
    (mapc #'eglot--apply-workspace-edit arguments))

  (defun my/jdtls-contact (_interactive)
    "Return the JDT-LS server contact for eglot."
    (let* ((install-dir (expand-file-name "eglot-java/" user-emacs-directory))
           (launcher    (car (file-expand-wildcards
                              (expand-file-name "plugins/org.eclipse.equinox.launcher_*.jar"
                                                install-dir))))
           (config      (expand-file-name "config_linux" install-dir))
           (workspace   (expand-file-name
                         (md5 (project-root (project-current t)))
                         (expand-file-name "eglot-java-eclipse-jdt-cache/" user-emacs-directory))))
      (unless launcher (user-error "JDT-LS launcher not found in %s" install-dir))
      (unless (file-directory-p workspace) (make-directory workspace t))
      `(my/jdtls
        ,(executable-find "java")
        "-Declipse.application=org.eclipse.jdt.ls.core.id1"
        "-Dosgi.bundles.defaultStartLevel=4"
        "-Declipse.product=org.eclipse.jdt.ls.core.product"
        ,@my/jdtls-jvm-args
        "-jar" ,launcher
        "-configuration" ,config
        "-data" ,workspace)))

  (add-to-list 'eglot-server-programs '((java-mode java-ts-mode) . my/jdtls-contact))

  (add-hook 'java-mode-hook    #'eglot-ensure)
  (add-hook 'java-ts-mode-hook #'eglot-ensure)

  ;; JDTLS workspace configuration.  Keys mirror VS Code's java.* settings.
  (setq-default eglot-workspace-configuration
                `(:java
                  ( :import
                    ( :exclusions
                      ["**/node_modules/**"
                       "**/.metadata/**"
                       "**/archetype-resources/**"
                       "**/META-INF/maven/**"
                       "**/target/generated-sources/**"
                       "**/target/generated-test-sources/**"
                       "**/spotless/**"])
                    :configuration
                    ( :runtimes
                      [( :name "JavaSE-17"
                         :path "/home/cgrover/.sdkman/candidates/java/17.0.20-tem/")
                       ( :name "JavaSE-21"
                         :path "/home/cgrover/.sdkman/candidates/java/21.0.12+1.1-tem/"
                         :default t)])
                    :compile
                    ( :nullAnalysis
                      ( :mode "automatic"
                        :nonnull ["org.jspecify.annotations.NonNull"]
                        :nullable ["org.jspecify.annotations.Nullable"]))
                    :completion
                    ( :filteredTypes
                      ["com.google.common.base.Optional" "org.testcontainers.shaded.*"
                       "org.apache.el.*" "org.parboiled2.*"]
                      :favoriteStaticMembers
                      ["org.springframework.test.web.client.match.MockRestRequestMatchers.*"
                       "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*"
                       "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*"
                       "org.springframework.test.web.servlet.result.MockMvcResultHandlers.*"
                       "org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.*"
                       "java.util.stream.Collectors.*"
                       "org.awaitility.Awaitility.await"
                       "com.tngtech.archunit.lang.syntax.ArchRuleDefinition.*"
                       "com.tngtech.archunit.library.Architectures.*"
                       "org.assertj.core.api.Assertions.*"
                       "org.assertj.core.api.Assumptions.*"
                       "org.junit.jupiter.params.provider.Arguments.*"
                       "org.junit.jupiter.api.Named.named"]
                      :maxResults 15
                      :guessMethodArguments :json-false)
                    :autobuild ( :enabled t)
                    :maven ( :downloadSources t)
                    :format ( :enabled :json-false)
                    :trace ( :server "off"))))

  ;; jdt:// URI handler; covers both .class? and .java? URIs from newer JDT-LS.
  (defun my/jdtls-uri-handler (_operation &rest args)
    (let* ((uri (car args))
           (cache-dir (expand-file-name ".eglot-java" (project-root (project-current t))))
           (source-file
            (expand-file-name
             (save-match-data
               (when (string-match "jdt://contents/\\(.*?\\)/\\(.*\\)\\.\\(?:class\\|java\\)\\?" uri)
                 (format "%s.java"
                         (replace-regexp-in-string "/" "." (match-string 2 uri) t t))))
             cache-dir)))
      (unless (file-readable-p source-file)
        (let ((content (jsonrpc-request (eglot-current-server)
                                        :java/classFileContents (list :uri uri)))
              (metadata-file (format "%s.%s.metadata"
                                     (file-name-directory source-file)
                                     (file-name-base source-file))))
          (unless (file-directory-p cache-dir) (make-directory cache-dir t))
          (with-temp-file source-file (insert content))
          (with-temp-file metadata-file (insert uri))))
      source-file))

  (add-to-list 'file-name-handler-alist '("\\`jdt://" . my/jdtls-uri-handler)))


;; lsp-java named source-attachment buffers "Foo.java(<pkg>(Bar.class)"
;; which doesn't end in .java; eglot-java may do the same.
(add-to-list 'auto-mode-alist '("\\.java(" . java-ts-mode))

;; ========== DEBUGGING (DAP) ==========
;; dap-mode is LSP-agnostic; works alongside eglot.

(use-package dap-mode
  :config (dap-auto-configure-mode))

(defun my/mvn-force-test ()
  "Run spotless:apply and test for the current buffer's test class."
  (interactive)
  (let* ((class-name (file-name-base (buffer-file-name)))
         (project-root (projectile-project-root))
         (cmd (format "mvn spotless:apply test -Dtest=%s" class-name)))
    (let ((default-directory project-root))
      (compile cmd))))

(use-package dap-java
  :ensure nil
  :bind (("C-c t c" . dap-java-run-test-class)
         ("C-c t m" . dap-java-run-test-method)
         ("C-c t t" . dap-java-run-last-test)
         ("C-c t f" . my/mvn-force-test)))

;; ========== MISC ==========

(use-package which-key
  :ensure nil
  :config (which-key-mode))

(use-package hydra)

(use-package treemacs
  :custom
  (treemacs-width 35)
  (treemacs-position 'left)
  (treemacs-is-never-other-window t)
  (treemacs-no-delete-other-windows t)
  (treemacs-sorting 'alphabetic-asc)
  (treemacs-follow-after-init nil)
  (treemacs-expand-after-init t)
  (treemacs-expand-added-projects t)
  (treemacs-recenter-after-file-follow nil)
  (treemacs-project-follow-cleanup nil)
  (treemacs-project-follow-into-home nil)
  (treemacs-file-follow-delay 0.2)
  (treemacs-persist-file (expand-file-name ".treemacs-persist" user-emacs-directory))
  :bind (("M-0"     . treemacs)
         ("C-c t 0" . treemacs-select-window))
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-project-follow-mode t))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :bind (("C-c p t" . treemacs-projectile)))

;; No lsp-treemacs equivalent for eglot; use treemacs standalone.

(provide 'my-eglot)
;;; my-eglot.el ends here
