;;; .yas-setup.el --- Java snippet setup -*- lexical-binding: t; -*-

;; Author: Cullen Grover

;;; Commentary:

;;  Utilities for Java snippets

;;; Code:

(defun find-build-file-dir (path)
  "Test if PATH has a Java build file."
  (interactive)
  (setq build-files '("pom.xml" "build.gradle"))
  (message "Testing '%s'" path)
  (let (build-file-dir)
    (dolist (build-file build-files build-file-dir)
      (message "path=%s file=%s res=%s" path build-file build-file-dir)
      (setq found-dir (locate-dominating-file path build-file))
      (if found-dir
          (setq build-file-dir found-dir)
          nil))))

(defun path-to-java-package ()
  "Turn the current path into a Java package."
  (interactive)
  ;; using the example /some/dir/project-foo/module-foo/src/test/java/com/foo/FooTest.java
  ;; find the nearest build file from the current file
  ;; 
  ;; /some/dir/project-foo/module-foo/
  (setq build-root (find-build-file-dir (symbol-value 'default-directory)))
  ;; src/test/java/com/foo/FooTest.java
  (setq rel-to-root (file-relative-name
                     buffer-file-name
                     build-root))
  ;; src/test/java/com/foo/
  (setq minus-file (file-name-directory rel-to-root))
  ;; com/foo/
  (setq minus-src-java (replace-regexp-in-string
                        "^src\\/\\w+\\/java\\/"
                        ""
                        minus-file))
  ;; com/foo
  (setq trimmed-dirs (string-trim-right minus-src-java "\\/"))
  ;; com.foo
  (replace-regexp-in-string "\\/" "." trimmed-dirs))

(provide '.yas-setup)
;;; .yas-setup.el ends here
