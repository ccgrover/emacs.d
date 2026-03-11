;;; my-plantuml.el --- plantuml packages -*- lexical-binding: t; -*-

;;; Commentary:

;;  Packages & config for plantuml diagrams

;;; Code:

(defcustom my-plantuml-jar-path "~/Tools/plantuml/plantuml.jar"
  "The font to use for monospaced (fixed width) text."
  :type '(string)
  :group 'my-emacs)

(use-package plantuml-mode
  :config
  (setq plantuml-jar-path my-plantuml-jar-path)
  (setq plantuml-default-exec-mode 'jar)
  ;; (setq plantuml-output-type "png")

  (add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))

  ;; Disable plantuml-mode's built-in completion to avoid conflicts with corfu
  (add-hook 'plantuml-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions nil)))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '(;; other Babel languages
     (plantuml . t)))
  )

(use-package ob-plantuml
  :ensure nil ; built-in
  :config
  (setq org-plantuml-jar-path
        (expand-file-name my-plantuml-jar-path)))

(use-package mermaid-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.mermaid\\'" . mermaid-mode))
  (add-to-list 'auto-mode-alist '("\\.mmd\\'"     . mermaid-mode)))

(provide 'my-plantuml)
;;; my-plantuml.el ends here
