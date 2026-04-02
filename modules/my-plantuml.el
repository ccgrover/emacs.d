;;; my-plantuml.el --- plantuml packages -*- lexical-binding: t; -*-

;;; Commentary:

;;  Packages & config for plantuml diagrams

;;; Code:

(defcustom my-plantuml-jar-path "~/Tools/plantuml/plantuml.jar"
  "Path to the PlantUML jar file."
  :type '(string)
  :group 'my-emacs)

(use-package plantuml-mode
  :config
  ;; Only configure jar path if it exists
  (when (file-exists-p (expand-file-name my-plantuml-jar-path))
    (setq plantuml-jar-path my-plantuml-jar-path)
    (setq plantuml-default-exec-mode 'jar))
  ;; (setq plantuml-output-type "png")

  (add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))

  ;; Fix completion to use modern completion-at-point instead of obsolete function
  (defun my/plantuml-completion-at-point-fixed ()
    "Fixed version of plantuml completion that doesn't move point.
Original uses `beginning-of-thing' and `end-of-thing' which move point as a side effect."
    (let* ((bounds (bounds-of-thing-at-point 'symbol))
           (thing-start (car bounds))
           (thing-end (cdr bounds)))
      (when bounds
        (list thing-start
              thing-end
              plantuml-kwdList
              '(:exclusive no)))))

  (defun my/plantuml-setup-completion ()
    "Replace obsolete completion function with fixed one for Corfu."
    (setq-local completion-at-point-functions
                (list #'my/plantuml-completion-at-point-fixed)))

  (defun my/plantuml-disable-electric-indent ()
    "Disable automatic indentation in plantuml-mode."
    (electric-indent-local-mode -1))

  (add-hook 'plantuml-mode-hook #'my/plantuml-setup-completion)
  (add-hook 'plantuml-mode-hook #'my/plantuml-disable-electric-indent)

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
